# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_activities
#
#  id                    :uuid             not null, primary key
#  voting_indicator_uuid :string
#  scorecard_uuid        :string
#  content               :text
#  selected              :boolean
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :indicator_activity do
  end

  factory :strength_indicator_activity do
    content { FFaker::Name.name }
    voting_indicator
    scorecard
  end

  factory :weakness_indicator_activity do
    content { FFaker::Name.name }
    voting_indicator
    scorecard
  end

  factory :suggested_indicator_activity do
    content { FFaker::Name.name }
    voting_indicator
    scorecard
  end
end
