# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_actions
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  predefined     :boolean          default(TRUE)
#  kind           :integer
#  indicator_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe IndicatorAction, type: :model do
  it { is_expected.to belong_to(:indicator).with_foreign_key(:indicator_uuid).with_primary_key(:uuid).optional }
  it { is_expected.to have_many(:proposed_indicator_actions).dependent(:destroy) }
  it { is_expected.to have_many(:voting_indicators).through(:proposed_indicator_actions) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:code) }

  describe "validates code presence" do
    subject { described_class.new(predefined: false) }

    it { is_expected.not_to validate_presence_of(:code) }
  end

  describe "validates code uniqueness" do
    let!(:action1) { create(:indicator_action, code: "1111") }

    context "the same indicator" do
      let(:action2) { build(:indicator_action, indicator_uuid: action1.indicator_uuid, code: "1111") }
      let(:action3) { build(:indicator_action, indicator_uuid: action1.indicator_uuid, code: "1112") }

      it { expect(action2.valid?).to be_falsey }
      it { expect(action3.valid?).to be_truthy }
    end

    context "different indicator" do
      let(:action2) { build(:indicator_action, code: "1111") }

      it { expect(action2.valid?).to be_truthy }
    end
  end
end
