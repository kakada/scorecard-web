# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  code           :string
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :category do
    name        { FFaker::Name.name }
    code        { name.upcase.split(" ").map { |n| n[0] }.join("") }
    program

    trait :with_indicators do
      transient do
        indicator_count { 1 }
      end

      after(:create) do |category, evaluator|
        create_list(:indicator, evaluator.indicator_count, :with_languages_indicators, categorizable: category)
      end
    end

    trait :with_parent do
      after(:create) do |category, evaluator|
        category.parent_id = create(:category, program_id: category.program_id).id
      end
    end
  end
end
