# frozen_string_literal: true

# == Schema Information
#
# Table name: static_pages
#
#  id         :uuid             not null, primary key
#  slug       :string           not null
#  content_en :text
#  content_km :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :static_page do
    sequence(:slug) { |n| "static_page_#{n}" }
    content_en { "<p>English content</p>" }
    content_km { "<p>Khmer content</p>" }
  end
end
