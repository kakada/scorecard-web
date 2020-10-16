# frozen_string_literal: true

class Category < ApplicationRecord
  acts_as_nested_set scope: [:program_id]

  belongs_to :program

  validates :name, presence: true
  validates :code, presence: true
end
