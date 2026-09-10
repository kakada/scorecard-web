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
FactoryBot.define do
  factory :indicator_activity_category do
    sequence(:name_en) { |n| "Waste Category #{n}" }
    sequence(:name_km) { |n| "ប្រភេទសំណល់ #{n}" }
    description_en { "Category description" }
    description_km { "សេចក្ដីពិពណ៌នា" }
    association :program
  end
end
