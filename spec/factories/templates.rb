# frozen_string_literal: true

# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :template do
    name        { FFaker::Name.name }
    program

    trait :with_indicators do
      transient do
        indicator_count { 1 }
      end

      after(:create) do |template, evaluator|
        create_list(:indicator, evaluator.indicator_count, :with_languages_indicators, categorizable: template)
      end
    end
  end
end
