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
#  indicator_activity_category_id :uuid
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class IndicatorActivity < ApplicationRecord
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true
  belongs_to :indicator_activity_category, optional: true

  default_scope { order(created_at: :asc) }
  scope :selecteds, -> { where(selected: true) }

  def indicator_activity_category_name
    indicator_activity_category&.name
  end

  def indicator_activity_category_description
    indicator_activity_category&.description
  end
end
