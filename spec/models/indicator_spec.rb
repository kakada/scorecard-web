# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#  image              :string
#  uuid               :string
#  audio              :string
#  type               :string           default("Indicators::PredefineIndicator")
#  deleted_at         :datetime
#  thematic_id        :uuid
#
require "rails_helper"

RSpec.describe Indicator, type: :model do
  it { is_expected.to belong_to(:categorizable).touch(true) }
  it { is_expected.to have_many(:languages_indicators).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:languages_indicators) }
  it { is_expected.to validate_presence_of(:name) }

  it "should touch the categorizable" do
    indicator = build(:indicator)
    expect(indicator.categorizable).to receive(:touch)
    indicator.save!
  end

  describe "Validate uniq name" do
    context "Predefine indicator" do
      let!(:indicator1) { create(:indicator, name: "work on time") }
      let!(:indicator2) { build(:indicator, name: "work on time", categorizable: indicator1.categorizable) }

      it { expect(indicator2.save).to be_falsey }

      it "has uniq name error" do
        indicator2.save
        expect(indicator2.errors.full_messages).to eq ["Name ត្រូវបានគេយកទៅហើយ"]
      end
    end

    context "Custom indicator" do
      let!(:indicator1) { create(:indicator, name: "work on time", type: "Indicators::CustomIndicator") }
      let!(:indicator2) { build(:indicator, name: "work on time", type: "Indicators::CustomIndicator", categorizable: indicator1.categorizable) }

      it { expect(indicator2.save).to be_truthy }
    end
  end
end
