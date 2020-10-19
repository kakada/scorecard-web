# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ScorecardType < ApplicationRecord
  belongs_to :program

  validates :name, presence: true
end
