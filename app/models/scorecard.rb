# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  conducted_year        :integer
#  conducted_date        :datetime
#  province_code         :string(2)
#  district_code         :string(4)
#  commune_code          :string(6)
#  category              :integer
#  sector                :string
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  caf_members           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Scorecard < ApplicationRecord
  serialize :caf_members, Array

  enum category: {
    community: 1,
    self_accessment: 2
  }

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
