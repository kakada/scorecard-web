# frozen_string_literal: true

FactoryBot.define do
  factory :static_page do
    sequence(:slug) { |n| "static_page_#{n}" }
    content_en { "<p>English content</p>" }
    content_km { "<p>Khmer content</p>" }
  end
end
