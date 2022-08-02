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
FactoryBot.define do
  factory :participant do
    scorecard
    age      { rand(20..65) }
    gender   { Participant::GENDERS.sample }
  end
end
