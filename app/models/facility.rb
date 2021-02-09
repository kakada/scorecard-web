# frozen_string_literal: true

# == Schema Information
#
# Table name: facilities
#
#  id             :bigint           not null, primary key
#  code           :string
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Facility < ApplicationRecord
  include Categorizable

  acts_as_nested_set scope: [:program_id]

  belongs_to :program

  validates :name, presence: true
  validates :code, presence: true

  SUBSETS = [
    { code: 'ps', name: 'Primary School', dataset: "PrimarySchool" }
  ]
end
