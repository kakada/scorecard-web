# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id          :uuid             not null, primary key
#  province_id :string
#  district_id :string
#  commune_id  :string
#  reference   :string
#  data        :jsonb
#  program_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Jaap < ApplicationRecord
  # Constant
  DATA_CHILD_MAX_DEPTH = 3

  # Uploader
  mount_uploader :reference, JaapReferenceUploader

  # Associations
  belongs_to :program

  # Validations
  validates :province_id, presence: true
  validates :district_id, presence: true
  validates :commune_id, presence: true

  def commune
    Pumi::Commune.find_by_id(commune_id)
  end
end
