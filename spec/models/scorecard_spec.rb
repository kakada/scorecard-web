# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                        :bigint           not null, primary key
#  uuid                      :string
#  unit_type_id              :integer
#  facility_id               :integer
#  name                      :string
#  description               :text
#  province_id               :string(2)
#  district_id               :string(4)
#  commune_id                :string(6)
#  year                      :integer
#  conducted_date            :datetime
#  number_of_caf             :integer
#  number_of_participant     :integer
#  number_of_female          :integer
#  planned_start_date        :datetime
#  planned_end_date          :datetime
#  status                    :integer
#  program_id                :integer
#  local_ngo_id              :integer
#  scorecard_type            :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  location_code             :string
#  number_of_disability      :integer
#  number_of_ethnic_minority :integer
#  number_of_youth           :integer
#  number_of_id_poor         :integer
#  creator_id                :integer
#  locked_at                 :datetime
#  primary_school_code       :string
#  downloaded_count          :integer          default(0)
#  progress                  :integer
#  language_conducted_code   :string
#  finished_date             :datetime
#  running_date              :datetime
#  deleted_at                :datetime
#
require "rails_helper"

RSpec.describe Scorecard, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name("User") }
  it { is_expected.to belong_to(:local_ngo).optional }
  it { is_expected.to belong_to(:unit_type).class_name("Facility") }
  it { is_expected.to belong_to(:facility) }
  it { is_expected.to belong_to(:location).optional }

  it { is_expected.to have_many(:facilitators).dependent(:destroy) }
  it { is_expected.to have_many(:cafs).through(:facilitators) }
  it { is_expected.to have_many(:participants).dependent(:destroy) }
  it { is_expected.to have_many(:custom_indicators).dependent(:destroy) }
  it { is_expected.to have_many(:raised_indicators).dependent(:destroy) }
  it { is_expected.to have_many(:voting_indicators).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:unit_type_id) }
  it { is_expected.to validate_presence_of(:facility_id) }
  it { is_expected.to validate_presence_of(:province_id) }
  it { is_expected.to validate_presence_of(:district_id) }
  it { is_expected.to validate_presence_of(:commune_id) }
  it { is_expected.to validate_presence_of(:planned_start_date) }
  it { is_expected.to validate_presence_of(:planned_end_date) }

  describe "#secure_uuid" do
    let!(:uuid) { SecureRandom.random_number(1..999999).to_s.rjust(6, "0") }
    let!(:scorecard1) { create(:scorecard, uuid: uuid) }
    let!(:scorecard2) { create(:scorecard, uuid: uuid) }

    it "generates uuid with 6 digits" do
      expect(scorecard2.uuid.length).to eq(6)
    end

    context "ensure unique uuid" do
      it { expect(scorecard2.uuid).not_to eq(uuid) }
    end
  end

  describe "validate #locked_scorecard" do
    let!(:scorecard) { create(:scorecard, locked_at: DateTime.now) }

    it { expect(scorecard.update(name: "test")).to be_falsey }

    it "raises is locked error" do
      scorecard.update(name: "test")
      expect(scorecard.errors[:base]).to eq([I18n.t("scorecard.record_is_locked")])
    end
  end

  describe "#lock_access!" do
    let!(:scorecard) { create(:scorecard) }
    before { scorecard.lock_access! }

    it { expect(scorecard.locked_at).not_to be_nil }
  end

  describe "#unlock_access!" do
    let!(:scorecard) { create(:scorecard, locked_at: Time.now.utc) }
    before { scorecard.unlock_access! }

    it { expect(scorecard.locked_at).to be_nil }
    it { expect(scorecard.update(name: "test")).to be_truthy }
  end

  describe "#access_locked?" do
    context "true" do
      let!(:scorecard) { create(:scorecard, locked_at: Time.now.utc) }

      it { expect(scorecard.access_locked?).to be_truthy }
    end

    context "false" do
      let!(:scorecard) { create(:scorecard, locked_at: nil) }

      it { expect(scorecard.access_locked?).to be_falsey }
    end
  end

  describe "validate planned_end_date" do
    let!(:local_ngo) { create(:local_ngo) }

    context "before planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.yesterday, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "equal to planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.today, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "after planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.tomorrow, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_falsey }

      it "raises errors" do
        scorecard.valid?
        expect(scorecard.errors.include? :planned_end_date)
      end
    end
  end

  describe "validate unique commune_id" do
    let!(:scorecard) { create(:scorecard, scorecard_type: :community_scorecard, year: 2021) }
    let!(:new_scorecard) { scorecard.dup }

    context "duplicate commune_id" do
      before { new_scorecard.save }

      it { expect(new_scorecard.save).to be_falsey }
      it { expect(new_scorecard.errors[:commune_id]).to include I18n.t("errors.messages.taken") }
    end

    context "different commune_id" do
      before {
        new_scorecard.commune_id = "none"
      }

      it { expect(new_scorecard.save).to be_truthy }
    end

    context "different scorecard_type" do
      before {
        new_scorecard.scorecard_type = :self_assessment
      }

      it { expect(new_scorecard.save).to be_truthy }
    end

    context "different facility_id" do
      let(:facility) {
        fac = scorecard.facility.dup
        fac.update(name_en: "new facility")
        fac
      }

      before {
        new_scorecard.facility = facility
      }

      it { expect(new_scorecard.save).to be_truthy }
    end

    context "different year" do
      before {
        new_scorecard.year = 2022
      }

      it { expect(new_scorecard.save).to be_truthy }
    end

    context "different program" do
      before {
        new_scorecard.program = create(:program)
      }

      it { expect(new_scorecard.save).to be_truthy }
    end

    context "commune_id none" do
      before {
        scorecard.update(commune_id: "none")
        new_scorecard.commune_id = "none"
      }

      it { expect(new_scorecard.save).to be_falsey }

      context "different district_id" do
        before {
          district = Pumi::District.where(province_id: scorecard.province_id).select { |dis| dis.id != scorecard.district_id }.first
          new_scorecard.district_id = district.id
        }

        it { expect(new_scorecard.save).to be_truthy }
      end
    end

    context "district_id none" do
      before {
        scorecard.update(commune_id: "none", district_id: "none")
        new_scorecard.commune_id = "none"
        new_scorecard.district_id = "none"
      }

      it { expect(new_scorecard.save).to be_falsey }

      context "different district_id" do
        before {
          district = Pumi::District.where(province_id: scorecard.province_id).first
          new_scorecard.district_id = district.id
        }

        it { expect(new_scorecard.save).to be_truthy }
      end
    end
  end

  describe "validate unique primary school code" do
    let!(:scorecard) { create(:scorecard, :with_primary_school) }
    let!(:new_scorecard) { scorecard.dup }

    context "duplicate" do
      before {
        new_scorecard.save
      }

      it { expect(new_scorecard.save).to be_falsey }
      it { expect(new_scorecard.errors[:primary_school_code]).to include I18n.t("errors.messages.taken") }
    end

    context "different primary school code" do
      before {
        ps = create(:primary_school, commune_id: scorecard.commune_id)
        new_scorecard.primary_school_code = ps.code
      }

      it { expect(new_scorecard.save).to be_truthy }
    end
  end
end
