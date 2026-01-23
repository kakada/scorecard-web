# frozen_string_literal: true

# == Schema Information
#
# Table name: unlock_requests
#
#  id              :uuid             not null, primary key
#  scorecard_uuid  :string
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
  it { is_expected.to define_enum_for(:status).with_values({ rejected: 0, approved: 1, submitted: 2 }) }
  it { is_expected.to belong_to(:scorecard).with_foreign_key(:scorecard_uuid) }
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

    it { expect(unlock_request.status).to eq("submitted") }
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
end
