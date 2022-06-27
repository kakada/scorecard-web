# frozen_string_literal: true

# == Schema Information
#
# Table name: voting_indicators
#
#  indicatorable_id   :integer
#  indicatorable_type :string
#  scorecard_uuid     :string
#  median             :integer
#  strength           :text
#  weakness           :text
#  suggested_action   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  uuid               :string           default("uuid_generate_v4()"), not null, primary key
#  display_order      :integer
#  indicator_uuid     :string
#
class VotingIndicator < ApplicationRecord
  belongs_to :scorecard, -> { with_deleted }, foreign_key: :scorecard_uuid, optional: true
  belongs_to :indicatorable, polymorphic: true, optional: true
  belongs_to :indicator, foreign_key: :indicator_uuid, primary_key: :uuid, optional: true
  has_many :ratings, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many :suggested_actions, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many :raised_indicators, foreign_key: :voting_indicator_uuid

  has_many   :indicator_activities, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many   :strength_indicator_activities, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many   :weakness_indicator_activities, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many   :suggested_indicator_activities, foreign_key: :voting_indicator_uuid, dependent: :destroy

  has_many   :proposed_indicator_actions, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many   :indicator_actions, through: :proposed_indicator_actions

  accepts_nested_attributes_for :suggested_actions, allow_destroy: true
  accepts_nested_attributes_for :indicator_activities, allow_destroy: true
  accepts_nested_attributes_for :proposed_indicator_actions, allow_destroy: true

  enum median: {
    very_bad: 1,
    bad: 2,
    acceptable: 3,
    good: 4,
    very_good: 5
  }

  serialize :strength, Array
  serialize :weakness, Array
  serialize :suggested_action, Array

  before_create :secure_uuid
  after_validation :set_indicator_uuid

  # Todo: after interim period of v1 and v2, they should be removed
  after_validation :set_strength_indicator_activities
  after_validation :set_weakness_indicator_activities
  after_validation :set_suggested_indicator_activities

  private
    def set_indicator_uuid
      self.indicator_uuid ||= indicatorable.try(:uuid)
    end

    def set_strength_indicator_activities
      strength.each do |st|
        strength_indicator_activities.find_or_initialize_by(content: st, scorecard_uuid: scorecard_uuid)
      end
    end

    def set_weakness_indicator_activities
      weakness.each do |st|
        weakness_indicator_activities.find_or_initialize_by(content: st, scorecard_uuid: scorecard_uuid)
      end
    end

    def set_suggested_indicator_activities
      suggested_actions.each do |action|
        activity = suggested_indicator_activities.find_or_initialize_by(content: action.content)
        activity.scorecard_uuid = action.scorecard_uuid
        activity.selected = action.selected
      end
    end
end
