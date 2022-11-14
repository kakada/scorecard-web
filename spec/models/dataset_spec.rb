# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :uuid             not null, primary key
#  code        :string
#  name_en     :string
#  name_km     :string
#  category_id :string
#  province_id :string
#  district_id :string
#  commune_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Dataset, type: :model do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:province_id) }

  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:category_id, :province_id, :district_id, :commune_id) }
  it { is_expected.to validate_uniqueness_of(:name_en).scoped_to(:category_id, :province_id, :district_id, :commune_id) }
  it { is_expected.to validate_uniqueness_of(:name_km).scoped_to(:category_id, :province_id, :district_id, :commune_id) }

  describe "validation presence of #district_id" do
    context "hierarchy has no district" do
      let!(:category) { build(:category, hierarchy: ["province"]) }
      subject { described_class.new(category: category) }

      it { is_expected.not_to validate_presence_of(:district_id) }
    end

    context "hierarchy has district" do
      let!(:category) { build(:category, hierarchy: ["province", "district"]) }
      subject { described_class.new(category: category) }

      it { is_expected.to validate_presence_of(:district_id) }
    end
  end

  describe "validation presence of #commune_id" do
    context "hierarchy has no commune" do
      let!(:category) { build(:category, hierarchy: ["province", "district"]) }
      subject { described_class.new(category: category) }

      it { is_expected.not_to validate_presence_of(:commune_id) }
    end

    context "hierarchy has commune" do
      let!(:category) { build(:category, hierarchy: ["province", "district", "commune"]) }
      subject { described_class.new(category: category) }

      it { is_expected.to validate_presence_of(:commune_id) }
    end
  end
end
