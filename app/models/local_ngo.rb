# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngos
#
#  id                  :bigint           not null, primary key
#  name                :string
#  province_id         :string(2)
#  district_id         :string(4)
#  commune_id          :string(6)
#  village_id          :string(8)
#  program_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  code                :string
#  target_province_ids :string
#
class LocalNgo < ApplicationRecord
  belongs_to :program
  has_many :cafs
  has_many :scorecards

  validates :name, presence: true, uniqueness: { scope: :program_id }

  def address(address_local = "address_km")
    address_code = village_id.presence || commune_id.presence || district_id.presence || province_id.presence
    return if address_code.nil?

    "Pumi::#{Location.location_kind(address_code).titlecase}".constantize.find_by_id(address_code).try("#{address_local}".to_sym)
  end

  def target_province_names
    return if target_province_ids.blank?

    Pumi::Province.all.select { |p| target_province_ids.split(",").include?(p.id) }.map(&:name_km).join(", ")
  end
end
