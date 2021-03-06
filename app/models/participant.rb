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
#
class Participant < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true

  before_create :secure_uuid

  GENDERS=%w(female male other)
end
