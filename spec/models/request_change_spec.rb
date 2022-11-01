# frozen_string_literal: true

# == Schema Information
#
# Table name: request_changes
#
#  id                  :uuid             not null, primary key
#  scorecard_uuid      :string
#  proposer_id         :integer
#  reviewer_id         :integer
#  year                :string
#  scorecard_type      :integer
#  province_id         :string
#  district_id         :string
#  commune_id          :string
#  primary_school_code :string
#  changed_reason      :text
#  rejected_reason     :text
#  status              :integer
#  resolved_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dataset_id          :uuid
#
require "rails_helper"

RSpec.describe RequestChange, type: :model do
  it { is_expected.to define_enum_for(:status).with_values({ rejected: 0, approved: 1, submitted: 2 }) }
  it { is_expected.to belong_to(:scorecard).with_foreign_key(:scorecard_uuid) }
  it { is_expected.to belong_to(:proposer).class_name("User") }
  it { is_expected.to belong_to(:reviewer).class_name("User").optional }

  it { is_expected.to validate_presence_of(:changed_reason) }

  describe "#before_validation, set_resolved_date" do
    let!(:scorecard) { create(:scorecard) }
    let!(:request_change) { build(:request_change, scorecard: scorecard, status: :approved) }

    before {
      request_change.valid?
    }

    it { expect(request_change.resolved_date).not_to be_nil }
  end

  describe "#before_create, set_status" do
    let(:request_change) { create(:request_change) }

    it { expect(request_change.status).to eq("submitted") }
  end

  describe "#after_save, update scorecard" do
    let!(:program) { create(:program) }
    let!(:reviewer) { create(:user, :staff, program: program) }
    let!(:proposer) { create(:user, :lngo, program: program) }
    let!(:scorecard) { create(:scorecard,
                          scorecard_type: :self_assessment,
                          year: 2020,
                          province_id: "01",
                          district_id: "0102",
                          commune_id: "010203",
                          program: program,
                          creator: reviewer
                        )
                      }

    let!(:request_change) {
      create(:request_change,
        scorecard: scorecard,
        scorecard_type: :community_scorecard,
        year: 2021,
        province_id: "01",
        district_id: "0102",
        commune_id: "010204",
        proposer: proposer
      )
    }

    before {
      request_change.update(status: :approved, reviewer: reviewer)
      scorecard.reload
    }

    it { expect(scorecard.year).to eq(2021) }
    it { expect(scorecard.scorecard_type).to eq("community_scorecard") }
    it { expect(scorecard.commune_id).to eq("010204") }
  end
end
