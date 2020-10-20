# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  unit_type_id          :integer
#  category_id           :integer
#  name                  :string
#  description           :text
#  province_id           :string(2)
#  district_id           :string(4)
#  commune_id            :string(6)
#  year                  :integer
#  conducted_date        :datetime
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  planned_start_date    :datetime
#  planned_end_date      :datetime
#  status                :integer
#  program_id            :integer
#  local_ngo_id          :integer
#  scorecard_type_id     :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require "rails_helper"

RSpec.describe Scorecard, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:local_ngo).optional }
  it { is_expected.to belong_to(:unit_type).class_name("Category") }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:scorecards_cafs) }
  it { is_expected.to have_many(:cafs).through(:scorecards_cafs) }
  it { is_expected.to have_many(:languages).through(:program) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:unit_type_id) }
  it { is_expected.to validate_presence_of(:category_id) }
  it { is_expected.to validate_presence_of(:province_id) }
  it { is_expected.to validate_presence_of(:district_id) }
  it { is_expected.to validate_presence_of(:commune_id) }

  describe "#secure_uuid" do
    let!(:uuid) { SecureRandom.random_number(1..999999).to_s.rjust(6, '0') }
    let!(:scorecard1) { create(:scorecard, uuid: uuid) }
    let!(:scorecard2) { create(:scorecard, uuid: uuid) }

    it "generates uuid with 6 digits" do
      expect(scorecard2.uuid.length).to eq(6)
    end

    context "ensure unique uuid" do
      it { expect(scorecard2.uuid).not_to eq(uuid) }
    end
  end
end
