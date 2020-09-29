# frozen_string_literal: true

# == Schema Information
#
# Table name: vote_people
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  gender         :string
#  age            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :vote_person do
  end
end
