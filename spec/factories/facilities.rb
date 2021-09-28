# frozen_string_literal: true

# == Schema Information
#
# Table name: facilities
#
#  id             :bigint           not null, primary key
#  code           :string
#  name_en        :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  dataset        :string
#  default        :boolean          default(FALSE)
#  name_km        :string
#
FactoryBot.define do
  factory :facility do
    name_en        { FFaker::Name.name }
    name_km        { name_en }
    code           { name.upcase.split(" ").map { |n| n[0] }.join("") }
    program

    trait :with_indicators do
      transient do
        indicator_count { 1 }
      end

      after(:create) do |facility, evaluator|
        create_list(:indicator, evaluator.indicator_count, :with_languages_indicators, categorizable: facility)
      end
    end

    trait :with_parent do
      after(:create) do |facility, evaluator|
        facility.parent_id = create(:facility, program_uuid: facility.program_uuid).id
      end
    end

    trait :dataset do
      dataset     { "ps" }

      before(:create) do |facility, evaluator|
        create(:primary_school)
      end
    end
  end
end
