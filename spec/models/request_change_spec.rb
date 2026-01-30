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

  describe "location field validations based on facility category" do
    let!(:program) { create(:program) }
    let!(:proposer) { create(:user, :lngo, program: program) }

    context "when province_id is not present" do
      let!(:facility) { create(:facility, :with_parent, program: program) }
      let!(:scorecard) { create(:scorecard, facility: facility, program: program) }
      let!(:request_change) { build(:request_change, scorecard: scorecard, proposer: proposer, province_id: nil) }

      it "does not require district_id" do
        request_change.district_id = nil
        request_change.commune_id = nil
        expect(request_change).to be_valid
      end

      it "does not require commune_id" do
        request_change.district_id = nil
        request_change.commune_id = nil
        expect(request_change).to be_valid
      end
    end

    context "when facility has no category (default hierarchy)" do
      let!(:facility) { create(:facility, :with_parent, program: program) }
      let!(:scorecard) { create(:scorecard, facility: facility, program: program) }
      let!(:request_change) { build(:request_change, scorecard: scorecard, proposer: proposer, province_id: "01") }

      it "requires district_id when province_id is present" do
        request_change.district_id = nil
        request_change.commune_id = "010203"
        expect(request_change).not_to be_valid
        expect(request_change.errors[:district_id]).to include("can't be blank")
      end

      it "requires commune_id when province_id is present" do
        request_change.district_id = "0102"
        request_change.commune_id = nil
        expect(request_change).not_to be_valid
        expect(request_change.errors[:commune_id]).to include("can't be blank")
      end
    end

    context "when facility has category with province-district hierarchy only" do
      let!(:category_health_center) { create(:category, :health_center) }
      let!(:facility) { create(:facility, :with_parent, category_id: category_health_center.id, program: program) }
      let!(:dataset)  { create(:dataset, category: category_health_center) }
      let!(:scorecard) { create(:scorecard, facility: facility, program: program, dataset: dataset) }
      let!(:request_change) { build(:request_change, scorecard: scorecard, proposer: proposer, province_id: "01") }

      it "requires district_id" do
        request_change.district_id = nil
        expect(request_change).not_to be_valid
        expect(request_change.errors[:district_id]).to include("can't be blank")
      end

      it "does not require commune_id" do
        request_change.district_id = "0102"
        request_change.commune_id = nil
        request_change.dataset_id = dataset.id
        expect(request_change).to be_valid
      end
    end

    context "when facility has category with province-district-commune hierarchy" do
      let!(:category_primary_school) { create(:category) }
      let!(:facility) { create(:facility, :with_parent, category_id: category_primary_school.id, program: program) }
      let!(:dataset)  { create(:dataset, category: category_primary_school) }
      let!(:scorecard) { create(:scorecard, facility: facility, program: program, dataset: dataset) }
      let!(:request_change) { build(:request_change, scorecard: scorecard, proposer: proposer, province_id: "01") }

      it "requires both district_id and commune_id" do
        request_change.district_id = nil
        request_change.commune_id = nil
        expect(request_change).not_to be_valid
        expect(request_change.errors[:district_id]).to include("can't be blank")
        expect(request_change.errors[:commune_id]).to include("can't be blank")
      end
    end

    context "dataset_id validation" do
      let!(:category_with_dataset) { create(:category, :primary_school_with_dataset) }
      let!(:facility_with_category) { create(:facility, :with_parent, category_id: category_with_dataset.id, program: program) }
      let!(:facility_without_category) { create(:facility, :with_parent, program: program) }

      it "requires dataset_id when facility has a category" do
        scorecard = create(:scorecard, facility: facility_with_category, program: program, dataset_id: category_with_dataset.datasets.first.id)
        request_change = build(:request_change, scorecard: scorecard, proposer: proposer, province_id: "01", district_id: "0102", commune_id: "010203")
        request_change.dataset_id = nil
        expect(request_change).not_to be_valid
        expect(request_change.errors[:dataset_id]).to include("can't be blank")
      end

      it "does not require dataset_id when facility has no category" do
        scorecard = create(:scorecard, facility: facility_without_category, program: program)
        request_change = build(:request_change, scorecard: scorecard, proposer: proposer, province_id: "01", district_id: "0102", commune_id: "010203")
        request_change.dataset_id = nil
        expect(request_change).to be_valid
      end
    end
  end
end
