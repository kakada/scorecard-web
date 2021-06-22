# frozen_string_literal: true

# == Schema Information
#
# Table name: suggested_actions
#
#  id                    :bigint           not null, primary key
#  voting_indicator_uuid :string
#  content               :string
#  selected              :boolean
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :suggested_action do
  end
end
