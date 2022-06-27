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

  # Todo: after interim period of v1 and v2, it should be removed
  after_validation :secure_uniqness
  after_create :create_proposed_indicator_actions

  private
    def secure_uniqness
      activity = IndicatorActivity.find_by(content: content, voting_indicator_uuid: voting_indicator_uuid, type: type)
      activity.delete if activity.present?
    end

    def create_proposed_indicator_actions
      voting_indicator.proposed_indicator_actions.create(
        scorecard_uuid: voting_indicator.scorecard.try(:uuid),
        selected: selected,
        kind: indicator_action_kind,
        indicator_action_attributes: {
          name: content,
          predefined: false,
          kind: indicator_action_kind,
          indicator_uuid: voting_indicator.indicator_uuid
        }
      )
    end

    def indicator_action_kind
      return "weakness" if type.downcase.match("weakness")
      return "strength" if type.downcase.match("strength")

      "suggested_action"
    end
end
