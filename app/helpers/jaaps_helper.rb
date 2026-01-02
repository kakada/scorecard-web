# frozen_string_literal: true

module JaapsHelper
  def province_name(province_id)
    return if province_id.blank?

    "Pumi::Province".constantize.find_by_id(province_id).try("name_#{I18n.locale}".to_sym)
  end

  def district_name(district_id)
    return if district_id.blank?

    "Pumi::District".constantize.find_by_id(district_id).try("name_#{I18n.locale}".to_sym)
  end

  def commune_name(commune_id)
    return if commune_id.blank?

    "Pumi::Commune".constantize.find_by_id(commune_id).try("name_#{I18n.locale}".to_sym)
  end

  def location_name(commune_id, address = "address_km")
    return if commune_id.blank?

    "Pumi::#{Location.location_kind(commune_id).titlecase}".constantize.find_by_id(commune_id).try("address_#{I18n.locale}".to_sym)
  end
end
