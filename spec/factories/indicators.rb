# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  tag_id             :integer
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :indicator do
    categorizable   { create(:facility) }
    tag
    name            { FFaker::Name.name }

    trait :with_languages_indicators do
      transient do
        count { 1 }
      end

      after(:create) do |indicator, evaluator|
        create_list(:languages_indicator, evaluator.count, indicator: indicator)
      end
    end
  end
end
