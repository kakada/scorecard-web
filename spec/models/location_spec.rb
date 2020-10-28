# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  code       :string           not null, primary key
#  name_en    :string           not null
#  name_km    :string           not null
#  kind       :string           not null
#  parent_id  :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to(:parent).class_name("Location").optional }
  it { is_expected.to have_many(:children).class_name("Location") }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:kind) }
  it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
  it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }

  describe "presence_of_lat_lng" do
    let(:location) { build(:location) }

    it "should valid when latitude and longitude are assigned" do
      location.latitude = 1.5
      location.longitude = 1.5
      expect(location).to be_valid
    end

    it "should valid when latitude and longitude are not assigned" do
      location.latitude = nil
      location.longitude = nil
      expect(location).to be_valid
    end

    it "should validate raise error when longitude has no value" do
      location.longitude = nil
      location.latitude = 1.5
      location.valid?
      expect(location.errors[:longitude]).to match_array "can't be blank"
    end

    it "should validate raise error when longitude has no value" do
      location.longitude = 1.5
      location.latitude = nil
      location.valid?
      expect(location.errors[:latitude]).to match_array "can't be blank"
    end
  end

  describe ".location_kind" do
    context "code is blank" do
      let(:code) { nil }

      it { expect(Location.location_kind(code)).to eq(nil) }
    end

    context "code length is 2" do
      let(:code) { "01" }

      it { expect(Location.location_kind(code)).to eq("province") }
    end

    context "code length is 4" do
      let(:code) { "0101" }

      it { expect(Location.location_kind(code)).to eq("district") }
    end

    context "code length is 6" do
      let(:code) { "010101" }

      it { expect(Location.location_kind(code)).to eq("commune") }
    end

    context "code length is 8" do
      let(:code) { "01010101" }

      it { expect(Location.location_kind(code)).to eq("village") }
    end
  end
end
