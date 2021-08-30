# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_knowledges
#
#  id         :uuid             not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ScorecardKnowledge < ApplicationRecord
  has_many :cafs

  validates :code, presence: true
  validates :name, presence: true
end
