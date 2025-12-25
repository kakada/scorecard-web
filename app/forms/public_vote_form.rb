# frozen_string_literal: true

# Form object for public vote submission
class PublicVoteForm
  include ActiveModel::Model

  attr_accessor :scorecard, :participant_age, :participant_gender,
                :participant_disability, :participant_minority,
                :participant_poor_card, :participant_youth,
                :ratings # Hash of { indicator_uuid => score }

  validates :scorecard, presence: true
  validates :participant_gender, presence: true
  validates :participant_age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 150 }

  validate :validate_all_indicators_rated

  def save
    return false unless valid?
    # Persist participant and ratings according to domain rules.
    # This is a placeholder for wiring into existing services/models.
    true
  end

  private
    def validate_all_indicators_rated
      return if scorecard.blank?
      required = scorecard.voting_indicators.pluck(:uuid)
      present = (ratings || {}).keys.map(&:to_s)
      missing = required - present
      if missing.any?
        errors.add(:ratings, :blank, message: "Please rate all indicators")
      end
    end
end
