# frozen_string_literal: true

# == Schema Information
#
# Table name: proposed_indicator_actions
#
#  id                    :uuid             not null, primary key
#  voting_indicator_uuid :string
#  indicator_action_id   :uuid
#  scorecard_uuid        :string
#  selected              :boolean          default(FALSE)
#  kind                  :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :proposed_indicator_action do
  end
end
