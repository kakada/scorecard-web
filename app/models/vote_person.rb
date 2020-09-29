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
class VotePerson < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid
  has_many :issue_ratings
  has_many :vote_issues, through: :issue_ratings
end
