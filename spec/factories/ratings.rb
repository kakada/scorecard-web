# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  scorecard_uuid        :string
#  score                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  uuid                  :string           default("uuid_generate_v4()"), not null, primary key
#  voting_indicator_uuid :string
#  participant_uuid      :string
#
FactoryBot.define do
  factory :rating do
    scorecard
    voting_indicator
    score { rand(1..5) }

    transient do
      participant { nil }
    end

    after(:build) do |rating, evaluator|
      rating.scorecard_uuid ||= rating.scorecard.id if rating.scorecard.present?
      rating.voting_indicator_uuid ||= rating.voting_indicator.uuid if rating.voting_indicator.present?
      rating.participant_uuid ||= evaluator.participant.uuid if evaluator.participant.present?
    end
  end
end
