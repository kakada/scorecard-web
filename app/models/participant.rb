# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  uuid           :string           not null, primary key
#  scorecard_uuid :string
#  age            :integer
#  gender         :string
#  disability     :boolean          default(FALSE)
#  minority       :boolean          default(FALSE)
#  poor_card      :boolean          default(FALSE)
#  youth          :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  countable      :boolean          default(TRUE)
#
class Participant < ApplicationRecord
  # Associations
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  # Callback
  before_create :secure_uuid
  after_commit :increase_scorecard_participant_count, on: :create
  after_commit :decrease_scorecard_participant_count, on: :destroy

  # Constants
  GENDERS=%w(female male other)
  GENDER_MALE = "male"
  GENDER_FEMALE = "female"
  GENDER_OTHER = "other"

  # Scopes
  scope :males,  -> { where(gender: GENDER_MALE) }
  scope :others, -> { where(gender: GENDER_OTHER) }
  scope :females, -> { where(gender: GENDER_FEMALE) }

  # Instance Methods
  def female?
    gender == GENDER_FEMALE
  end

  def male?
    gender == GENDER_MALE
  end

  private
    def increase_scorecard_participant_count
      return unless countable? && scorecard.present?

      Scorecard.update_counters(
        scorecard.id,
        number_of_participant: 1,
        number_of_female: (female? ? 1 : 0),
        number_of_youth: (youth? ? 1 : 0),
        number_of_disability: (disability? ? 1 : 0),
        number_of_ethnic_minority: (minority? ? 1 : 0),
        number_of_id_poor: (poor_card? ? 1 : 0)
      )
    end

    def decrease_scorecard_participant_count
      return unless countable? && scorecard.present?

      Scorecard.update_counters(
        scorecard.id,
        number_of_participant: -1,
        number_of_female: (female? ? -1 : 0),
        number_of_youth: (youth? ? -1 : 0),
        number_of_disability: (disability? ? -1 : 0),
        number_of_ethnic_minority: (minority? ? -1 : 0),
        number_of_id_poor: (poor_card? ? -1 : 0)
      )
    end
end
