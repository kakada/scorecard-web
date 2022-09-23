# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :uuid             not null, primary key
#  code        :string
#  name_en     :string
#  name_km     :string
#  category_id :string
#  province_id :string
#  district_id :string
#  commune_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Dataset < ApplicationRecord
  belongs_to :category

  validates :code, presence: true, uniqueness: { scope: [:category_id, :province_id, :district_id, :commune_id] }
  validates :name_en, presence: true, uniqueness: { scope: [:category_id, :province_id, :district_id, :commune_id] }
  validates :name_km, presence: true, uniqueness: { scope: [:category_id, :province_id, :district_id, :commune_id] }
  validates :commune_id, presence: true, if: -> { category&.hierarchy&.include?("commune") }
  validates :district_id, presence: true, if: -> { category&.hierarchy&.include?("district") }
  validates :province_id, presence: true

  def name
    self["name_#{I18n.locale}"]
  end

  def address
    address_code = commune_id.presence || district_id.presence || province_id.presence
    return if address_code.nil?

    "Pumi::#{Location.location_kind(address_code).titlecase}".constantize.find_by_id(address_code).try("address_#{I18n.locale}".to_sym)
  end

  def self.filter(params)
    scope = all
    scope = scope.where("code LIKE ? OR name_en LIKE ? OR name_km LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%") if params[:keyword].present?
    scope = scope.where(commune_id: params[:commune_id]) if params[:commune_id].present?
    scope = scope.where(district_id: params[:district_id]) if params[:district_id].present?
    scope = scope.where(province_id: params[:province_id]) if params[:province_id].present?
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope
  end
end
