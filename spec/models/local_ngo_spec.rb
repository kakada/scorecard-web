# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngos
#
#  id                  :bigint           not null, primary key
#  name                :string
#  province_id         :string(2)
#  district_id         :string(4)
#  commune_id          :string(6)
#  village_id          :string(8)
#  program_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  code                :string
#  target_province_ids :string
#  target_provinces    :string
#  website_url         :string
#
require "rails_helper"

RSpec.describe LocalNgo, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:cafs) }
  it { is_expected.to have_many(:scorecards) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:program_uuid) }

  describe "before_save, set target_provinces" do
    let!(:ngo) { create(:local_ngo, target_province_ids: "01,02") }
    let!(:province1) { Pumi::Province.find_by_id("01") }
    let!(:province2) { Pumi::Province.find_by_id("02") }

    it { expect(ngo.target_provinces).to eq("#{province1.name_km}, #{province2.name_km}") }
  end

  describe "#website_url" do
    subject { build(:local_ngo, website_url: "htp://invalidurl") }

    it "validates website_url" do
      subject.valid?

      expect(subject).not_to be_valid
      expect(subject.errors[:website_url]).to eq ["is invalid"]
    end
  end
end
