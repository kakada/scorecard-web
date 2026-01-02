# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id          :uuid             not null, primary key
#  province_id :string
#  district_id :string
#  commune_id  :string
#  reference   :string
#  data        :jsonb
#  program_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Jaap, type: :model do
  it { is_expected.to validate_presence_of(:province_id) }
  it { is_expected.to validate_presence_of(:district_id) }
  it { is_expected.to validate_presence_of(:commune_id) }
  it { is_expected.to belong_to(:program) }

  describe "data field" do
    let(:jaap) { build(:jaap) }

    it "has default structure" do
      expect(jaap.data).to eq({})
    end
  end
end
