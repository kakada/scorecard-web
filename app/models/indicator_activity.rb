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
class IndicatorActivity < ApplicationRecord
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  default_scope { order(created_at: :asc) }
  scope :selecteds, -> { where(selected: true) }
end
