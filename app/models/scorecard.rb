# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  sector_id             :integer
#  category_id           :integer
#  name                  :string
#  description           :text
#  province_id           :string(2)
#  district_id           :string(4)
#  commune_id            :string(6)
#  address               :string
#  lat                   :string
#  lng                   :string
#  conducted_date        :datetime
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  planned_start_date    :datetime
#  planned_end_date      :datetime
#  status                :integer
#  program_id            :integer
#  local_ngo_id          :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Scorecard < ApplicationRecord
  serialize :caf_members, Array

  has_many :scorecards_cafs
  has_many :cafs, through: :scorecards_cafs
  belongs_to :sector, class_name: 'Category'
  belongs_to :category

  before_create :secure_uuid

  has_many :scorecards_cafs
  has_many :cafs, through: :scorecards_cafs

  before_create :secure_uuid

  SECTORS = %w(primary_school health_center commune)

  def location
    ::Pumi::Commune.find_by_id(commune_code).try(:address_km)
  end

  private
    def secure_uuid
      self.uuid ||= SecureRandom.hex(3)

      return unless self.class.exists?(uuid: uuid)

      self.uuid = SecureRandom.hex(4)
      secure_uuid
    end
end
