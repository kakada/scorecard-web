# frozen_string_literal: true

# == Schema Information
#
# Table name: predefined_facilities
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name_en       :string           not null
#  name_km       :string           not null
#  parent_code   :string
#  category_code :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :predefined_facility do
    sequence(:code) { |n| "PF#{n}" }
    sequence(:name_en) { |n| "Predefined Facility #{n}" }
    sequence(:name_km) { |n| "វិស័យកំណត់ #{n}" }
    parent_code { nil }
    category_code { nil }

    trait :with_parent do
      parent_code { "PA" }
    end
  end
end
