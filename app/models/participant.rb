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
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  before_create :secure_uuid

  GENDERS=%w(female male other)
  GENDER_MALE = "male"
  GENDER_FEMALE = "female"
  GENDER_OTHER = "other"

  scope :males, -> { where(gender: :male) }
  scope :others, -> { where(gender: :other) }

  def female?
    gender == GENDER_FEMALE
  end

  def male?
    gender == GENDER_MALE
  end
end
