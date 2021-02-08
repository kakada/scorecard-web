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
#
require "rails_helper"

RSpec.describe Scorecard, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name("User") }
  it { is_expected.to belong_to(:local_ngo).optional }
  it { is_expected.to belong_to(:unit_type).class_name("Facility") }
  it { is_expected.to belong_to(:facility) }
  it { is_expected.to belong_to(:location).optional }

  it { is_expected.to have_many(:facilitators) }
  it { is_expected.to have_many(:cafs).through(:facilitators) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:unit_type_id) }
  it { is_expected.to validate_presence_of(:facility_id) }
  it { is_expected.to validate_presence_of(:province_id) }
  it { is_expected.to validate_presence_of(:district_id) }
  it { is_expected.to validate_presence_of(:commune_id) }

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
      expect(scorecard.errors[:base]).to eq(["the recored is locked!"])
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
end
