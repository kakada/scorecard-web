# frozen_string_literal: true

# == Schema Information
#
# Table name: issue_ratings
#
#  id             :bigint           not null, primary key
#  vote_issue_id  :integer
#  vote_person_id :integer
#  score          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class IssueRating < ApplicationRecord
  belongs_to :vote_issue
  belongs_to :vote_person
end
