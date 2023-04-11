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
#  local_ngo_batch_id  :uuid
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
                                  message: I18n.t("local_ngo.invalid") }
  validate :verify_target_provinces

  before_save :set_target_provinces, if: :will_save_change_to_target_province_ids?
  before_create :secure_code

  def address(address_local = "address_km")
    address_code = village_id.presence || commune_id.presence || district_id.presence || province_id.presence
    return if address_code.nil?

    "Pumi::#{Location.location_kind(address_code).titlecase}".constantize.find_by_id(address_code).try("#{address_local}".to_sym)
  end

  private
    def set_target_provinces
      self.target_provinces = Pumi::Province.all.select { |p| target_province_ids.to_s.split(",").include?(p.id) }.sort_by { |x| x.id }.map(&:name_km).join(", ")
    end

    def verify_target_provinces
      return unless target_province_ids.present?

      errors.add :target_province_ids, "is invalid" if !valid_target_provinces?
    end

    def valid_target_provinces?
      province_ids.length == provinces.length
    end

    def province_ids
      @province_ids ||= target_province_ids.to_s.delete(" ").split(",")
    end

    def provinces
      @provinces ||= Pumi::Province.all.select { |p| province_ids.include?(p.id) }
    end
end
