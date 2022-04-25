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
#  target_provinces    :string
#  website_url         :string
#  deleted_at          :datetime
#
class LocalNgo < ApplicationRecord
  include LocalNgos::Filter
  include LocalNgos::Removing

  belongs_to :program
  has_many :cafs, dependent: :destroy
  has_many :scorecards

  acts_as_paranoid if column_names.include? "deleted_at"

  validates :name, presence: true, uniqueness: { scope: :program_id }
  validates :website_url, url: {  allow_blank: true,
                                  no_local: true,
                                  public_suffix: true,
                                  message: I18n.t("local_ngo.website_url.invalid") }

  before_save :set_target_provinces, if: :will_save_change_to_target_province_ids?

  def address(address_local = "address_km")
    address_code = village_id.presence || commune_id.presence || district_id.presence || province_id.presence
    return if address_code.nil?

    "Pumi::#{Location.location_kind(address_code).titlecase}".constantize.find_by_id(address_code).try("#{address_local}".to_sym)
  end

  private
    def set_target_provinces
      self.target_provinces = Pumi::Province.all.select { |p| target_province_ids.to_s.split(",").include?(p.id) }.sort_by { |x| x.id }.map(&:name_km).join(", ")
    end
end
