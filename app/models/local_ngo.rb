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
#
class LocalNgo < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :cafs
  has_many :scorecards

  validates :name, presence: true, uniqueness: { scope: :program_uuid }
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

  class << self
    def filter(params)
      scope = all
      scope = by_keyword(params[:keyword], scope) if params[:keyword].present?
      scope = scope.where(program_uuid: params[:program_uuid]) if params[:program_uuid].present?
      scope
    end

    private
      def by_keyword(keyword, scope)
        return scope unless keyword.present?

        province_ids = Pumi::Province.all.select { |p| p.name_km.downcase.include?(keyword.downcase) || p.name_en.downcase.include?(keyword.downcase) }.map(&:id)

        scope.where("LOWER(name) LIKE ? OR LOWER(target_provinces) LIKE ? OR province_id IN (?)", "%#{keyword.downcase}%", "%#{keyword.downcase}%", province_ids)
      end
  end

  private
    def set_target_provinces
      self.target_provinces = Pumi::Province.all.select { |p| target_province_ids.split(",").include?(p.id) }.sort_by { |x| x.id }.map(&:name_km).join(", ")
    end
end
