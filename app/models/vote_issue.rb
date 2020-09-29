# frozen_string_literal: true

# == Schema Information
#
# Table name: vote_issues
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  content        :string
#  audio          :string
#  display_order  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class VoteIssue < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid
  has_many :issue_ratings
  has_many :vote_people, through: :issue_ratings
  has_many :swots
end
