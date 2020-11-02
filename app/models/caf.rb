# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id            :bigint           not null, primary key
#  name          :string
#  sex           :string
#  date_of_birth :string
#  tel           :string
#  address       :string
#  local_ngo_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Caf < ApplicationRecord
  belongs_to :local_ngo
  has_many :scorecards_caf
  has_many :scorecards, through: :scorecards_caf

  GENDERS = %w(female male other)

  validates :name, presence: true
  validates :sex, inclusion: { in: GENDERS }, allow_blank: true
end
