# frozen_string_literal: true

require "rails_helper"

RSpec.describe IndicatorActivityCategory, type: :model do
  it { is_expected.to have_many(:indicator_activities).dependent(:nullify) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }

  describe "#name" do
    it "returns localized name by locale" do
      category = create(:indicator_activity_category, name_en: "Waste Generation", name_km: "ការបោះចោលសំណល់")

      I18n.with_locale(:km) do
        expect(category.name).to eq("ការបោះចោលសំណល់")
      end
    end
  end
end
