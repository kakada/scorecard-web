# frozen_string_literal: true

module Scorecards::Location
  extend ActiveSupport::Concern

  included do
    before_validation :set_location_code

    def location_name(address = "address_km")
      return if location_code.blank?

      "Pumi::#{Location.location_kind(location_code).titlecase}".constantize.find_by_id(location_code).try("#{address}".to_sym)
    end

    def province
      Pumi::Province.find_by_id(province_id)["name_#{I18n.locale}"]
    end

    def district
      Pumi::District.find_by_id(district_id).try("name_#{I18n.locale}")
    end

    def commune
      Pumi::Commune.find_by_id(commune_id).try("name_#{I18n.locale}")
    end

    private
      def set_location_code
        self.location_code = commune_id
        self.location_code = district_id if commune_id == "none"
        self.location_code = province_id if district_id == "none"
      end
  end
end
