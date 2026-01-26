# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                    :bigint           not null, primary key
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  tag_id                :integer
#  participant_uuid      :string
#  selected              :boolean          default(FALSE)
#  voting_indicator_uuid :string
#  indicator_uuid        :string
#
FactoryBot.define do
  factory :raised_indicator do
    tag
    scorecard     { create(:scorecard) }
    indicator     { create(:indicator) }
    indicator_uuid { indicator.uuid }
    participant   { create(:participant, scorecard: scorecard) }

    trait :custom do
      indicator { create(:indicator, :custom) }
    end
  end
end
