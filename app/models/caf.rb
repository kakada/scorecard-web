# == Schema Information
#
# Table name: cafs
#
#  id          :bigint           not null, primary key
#  name        :string
#  province_id :string(2)
#  district_id :string(4)
#  commune_id  :string(6)
#  address     :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Caf < ApplicationRecord
  belongs_to :local_ngo
  has_many :scorecards_caf
  has_many :scorecards, through: :scorecards_caf

  validates :name, presence: true
end
