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
#  type               :string           default("PredefinedIndicator")
#
require "rails_helper"

RSpec.describe Indicator, type: :model do
  it { is_expected.to belong_to(:categorizable).touch(true) }
  it { is_expected.to have_many(:languages_indicators).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:languages_indicators) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to([:categorizable_id, :categorizable_type]) }

  it "should touch the categorizable" do
    indicator = build(:indicator)
    expect(indicator.categorizable).to receive(:touch)
    indicator.save!
  end
end
