# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_activity_categories
#
#  id             :uuid             not null, primary key
#  name_en        :string
#  name_km        :string
#  description_en :text
#  description_km :text
#  display_order  :integer          default(0)
#  program_id     :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe IndicatorActivityCategory, type: :model do
  it { is_expected.to belong_to(:program) }
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

  describe "#description" do
    it "returns localized description by locale" do
      category = create(
        :indicator_activity_category,
        description_en: "Waste generated per household",
        description_km: "សំណល់ដែលបានបង្កើតក្នុងមួយគ្រួសារ"
      )

      I18n.with_locale(:km) do
        expect(category.description).to eq("សំណល់ដែលបានបង្កើតក្នុងមួយគ្រួសារ")
      end
    end

    it "falls back to description_en when the localized description is blank" do
      category = create(:indicator_activity_category, description_en: "Waste generated per household", description_km: nil)

      I18n.with_locale(:km) do
        expect(category.description).to eq("Waste generated per household")
      end
    end
  end

  describe "#set_display_order" do
    it "sets display_order to 1 for the first category in a program" do
      program = create(:program)
      category = build(:indicator_activity_category, program: program, display_order: nil)

      category.save!

      expect(category.reload.display_order).to eq(1)
    end

    it "increments display_order based on the highest existing value for the program" do
      program = create(:program)
      create(:indicator_activity_category, program: program, display_order: 5)
      category = build(:indicator_activity_category, program: program, display_order: nil)

      category.save!

      expect(category.reload.display_order).to eq(6)
    end

    it "does not override an explicitly assigned display_order" do
      category = create(:indicator_activity_category, display_order: 3)

      expect(category.reload.display_order).to eq(3)
    end

    it "scopes the increment to categories within the same program" do
      other_program = create(:program)
      create(:indicator_activity_category, program: other_program, display_order: 10)
      program = create(:program)
      category = build(:indicator_activity_category, program: program, display_order: nil)

      category.save!

      expect(category.reload.display_order).to eq(1)
    end
  end
end
