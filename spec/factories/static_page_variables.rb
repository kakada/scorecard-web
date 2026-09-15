# frozen_string_literal: true

# == Schema Information
#
# Table name: static_page_variables
#
#  id            :uuid             not null, primary key
#  key           :string           not null
#  variable_type :integer          default("text"), not null
#  value         :text
#  image         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :static_page_variable do
    sequence(:key) { |n| "VARIABLE_#{n}" }
    variable_type { :text }
    value { "Sample value" }
    description { "Sample description" }

    trait :url do
      variable_type { :url }
      value { "https://example.com" }
    end

    trait :image do
      variable_type { :image }
      value { nil }
      image { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/reference_image.png"), "image/png") }
    end
  end
end
