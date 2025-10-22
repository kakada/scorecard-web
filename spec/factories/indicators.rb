# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#  image              :string
#  uuid               :string
#  audio              :string
#  type               :string           default("Indicators::PredefineIndicator")
#  deleted_at         :datetime
#
FactoryBot.define do
  factory :indicator do
    categorizable   { create(:facility) }
    tag
    name            { FFaker::Name.name }

    trait :custom do
      type { "Indicators::CustomIndicator" }
    end

    trait :with_languages_indicators do
      transient do
        count { 1 }
      end

      after(:create) do |indicator, evaluator|
        evaluator.count.times do |i|
          indicator.categorizable.program.languages.each do |language|
            create(:languages_indicator, language: language, indicator: indicator)
          end
        end
      end
    end
  end
end
