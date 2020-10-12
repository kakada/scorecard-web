class Caf < ApplicationRecord
  belongs_to :program
  has_many :scorecards_caf
  has_many :scorecards, through: :scorecards_caf

  validates :name, presence: true
end
