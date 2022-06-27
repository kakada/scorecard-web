# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_actions
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  predefined     :boolean          default(TRUE)
#  kind           :integer
#  indicator_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :indicator_action do
    indicator
    name       { FFaker::Name.name }
    predefined { true }
    kind       { "suggested_action" }

    trait :custom do
      predefined { false }
    end
  end
end
