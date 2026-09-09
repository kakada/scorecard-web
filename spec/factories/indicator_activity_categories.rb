# frozen_string_literal: true

FactoryBot.define do
  factory :indicator_activity_category do
    sequence(:name_en) { |n| "Waste Category #{n}" }
    sequence(:name_km) { |n| "ប្រភេទសំណល់ #{n}" }
    description_en { "Category description" }
    description_km { "សេចក្ដីពិពណ៌នា" }
  end
end
