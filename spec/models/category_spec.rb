# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  hierarchy  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:datasets).dependent(:destroy) }
  it { is_expected.to have_many(:facilities) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:hierarchy) }

  describe "before_validation, #clean_hierarchy" do
    subject { described_class.new(hierarchy: ["", "  ", "province"]) }

    it "rejects all blank space" do
      subject.valid?
      expect(subject.hierarchy).to eq ["province"]
    end
  end
end
