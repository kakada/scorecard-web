# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_activities
#
#  id                    :uuid             not null, primary key
#  voting_indicator_uuid :string
#  scorecard_uuid        :string
#  content               :text
#  selected              :boolean
#  type                  :string
#  indicator_activity_category_id :uuid
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require "rails_helper"

RSpec.describe IndicatorActivity, type: :model do
  it { is_expected.to belong_to(:voting_indicator).with_foreign_key(:voting_indicator_uuid).optional }
  it { is_expected.to belong_to(:scorecard).with_foreign_key(:scorecard_uuid).optional }
  it { is_expected.to belong_to(:indicator_activity_category).optional }

  describe "default_scope" do
    it "orders by created_at ascending" do
      later = create(:indicator_activity, created_at: Time.zone.parse("2020-01-02 00:00:00"))
      earlier = create(:indicator_activity, created_at: Time.zone.parse("2020-01-01 00:00:00"))

      expect(described_class.all).to eq([earlier, later])
    end
  end

  describe ".selecteds" do
    it "returns only selected indicator activities" do
      selected = create(:indicator_activity, selected: true)
      create(:indicator_activity, selected: false)
      create(:indicator_activity, selected: nil)

      expect(described_class.selecteds).to contain_exactly(selected)
    end
  end

  describe "#indicator_activity_category_name" do
    it "returns the localized category name when available" do
      category = create(:indicator_activity_category, name_en: "Waste Generation", name_km: "ការបោះចោលសំណល់")
      activity = create(:indicator_activity, indicator_activity_category: category)

      I18n.with_locale(:km) do
        expect(activity.indicator_activity_category_name).to eq("ការបោះចោលសំណល់")
      end
    end
  end
end
