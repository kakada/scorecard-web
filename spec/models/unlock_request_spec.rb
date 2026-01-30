# frozen_string_literal: true

# == Schema Information
#
# Table name: unlock_requests
#
#  id              :uuid             not null, primary key
#  scorecard_id    :integer
#  proposer_id     :integer
#  reviewer_id     :integer
#  reason          :text
#  rejected_reason :text
#  status          :integer
#  resolved_date   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe UnlockRequest, type: :model do
  it { is_expected.to define_enum_for(:status).with_values({ pending: 0, rejected: 1, approved: 2 }) }
  it { is_expected.to belong_to(:scorecard) }
  it { is_expected.to belong_to(:proposer).class_name("User") }
  it { is_expected.to belong_to(:reviewer).class_name("User").optional }

  it { is_expected.to validate_presence_of(:reason) }

  describe "#before_validation, set_resolved_date" do
    let!(:scorecard) { create(:scorecard) }
    let!(:unlock_request) { build(:unlock_request, scorecard: scorecard, status: :approved) }

    before {
      unlock_request.valid?
    }

    it { expect(unlock_request.resolved_date).not_to be_nil }
  end

  describe "#before_create, set_status" do
    let(:unlock_request) { create(:unlock_request) }

    it { expect(unlock_request.status).to eq("pending") }
  end

  describe "#after_save, unlock scorecard" do
    let!(:program) { create(:program) }
    let!(:reviewer) { create(:user, :staff, program: program) }
    let!(:proposer) { create(:user, :lngo, program: program) }
    let!(:scorecard) {
      create(:scorecard,
        program: program,
        creator: reviewer,
        completed_at: Time.now,
        completor_id: proposer.id,
        progress: Scorecard::STATUS_COMPLETED
      )
    }

    let!(:unlock_request) {
      create(:unlock_request,
        scorecard: scorecard,
        proposer: proposer
      )
    }

    before {
      unlock_request.update(status: :approved, reviewer: reviewer)
      scorecard.reload
    }

    it { expect(scorecard.completed_at).to be_nil }
    it { expect(scorecard.progress).to eq(Scorecard::STATUS_IN_REVIEW) }
  end

  describe "callback notifications" do
    let!(:scorecard) { create(:scorecard) }
    let!(:proposer)  { create(:user, program: scorecard.program) }
    let!(:reviewer)  { create(:user, program: scorecard.program) }

    it "enqueues admin notification after create" do
      # Ensure there is at least one program admin in the scorecard program
      create(:user, program: scorecard.program)

      expect(UnlockRequestWorker).to receive(:perform_async)
        .with("notify_unlock_request_to_program_admins", kind_of(String))

      create(:unlock_request, scorecard: scorecard, proposer: proposer, reason: "Please unlock")
    end

    it "enqueues proposer approved notification after approve" do
      ur = create(:unlock_request, scorecard: scorecard, proposer: proposer, reason: "Please unlock")

      expect(UnlockRequestWorker).to receive(:perform_async)
        .with("notify_status_approved_to_proposer", ur.id)

      ur.update!(status: :approved, reviewer: reviewer)
    end

    it "enqueues proposer rejected notification after reject" do
      ur = create(:unlock_request, scorecard: scorecard, proposer: proposer, reason: "Please unlock")

      expect(UnlockRequestWorker).to receive(:perform_async)
        .with("notify_status_rejected_to_proposer", ur.id)

      ur.update!(status: :rejected, reviewer: reviewer, rejected_reason: "Not sufficient reason")
    end
  end
end
