# frozen_string_literal: true

module PumiLocation
  extend ActiveSupport::Concern

  included do
    def province
      return nil unless province_id.present?

      Pumi::Province.find_by_id(province_id)["name_#{I18n.locale}"]
    end

    def district
      return nil unless district_id.present?

      Pumi::District.find_by_id(district_id).try("name_#{I18n.locale}")
    end

    def commune
      return nil unless commune_id.present?

      Pumi::Commune.find_by_id(commune_id).try("name_#{I18n.locale}")
    end
  end
end
