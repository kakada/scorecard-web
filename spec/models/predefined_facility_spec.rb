# frozen_string_literal: true

# == Schema Information
#
# Table name: predefined_facilities
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name_en       :string           not null
#  name_km       :string           not null
#  parent_code   :string
#  category_code :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe PredefinedFacility, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_uniqueness_of(:code) }

  describe "#root?" do
    it "returns true when parent_code is nil" do
      facility = build(:predefined_facility, parent_code: nil)
      expect(facility.root?).to be true
    end

    it "returns false when parent_code is present" do
      facility = build(:predefined_facility, parent_code: "PA")
      expect(facility.root?).to be false
    end
  end

  describe "#parent" do
    let!(:parent_facility) { create(:predefined_facility, code: "PA") }
    let(:child_facility) { create(:predefined_facility, parent_code: "PA") }

    it "returns the parent facility" do
      expect(child_facility.parent).to eq(parent_facility)
    end
  end

  describe "#children" do
    let!(:parent_facility) { create(:predefined_facility, code: "PA") }
    let!(:child_facility) { create(:predefined_facility, parent_code: "PA") }

    it "returns the child facilities" do
      expect(parent_facility.children).to include(child_facility)
    end
  end
end
