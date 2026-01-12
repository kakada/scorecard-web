# frozen_string_literal: true

module Scorecards::Location
  extend ActiveSupport::Concern

  included do
    include PumiLocation

    before_validation :set_location_code

    def location_name(address = "address_km")
      return if location_code.blank?

      "Pumi::#{Location.location_kind(location_code).titlecase}".constantize.find_by_id(location_code).try("address_#{I18n.locale}".to_sym)
    end

    def conducted_place
      primary_school_name || commune || district
    end

    def location_short_detail
      return "#{location_name}" unless dataset.present?

      title = dataset.category.name
      str = I18n.locale == :km ? "#{title}#{dataset_name}" : "#{dataset_name} #{title},"

      [str, location_name].join(" ")
    end

    private
      def set_location_code
        self.location_code = commune_id
        self.location_code = district_id if commune_id == "none" || commune_id.blank?
        self.location_code = province_id if district_id == "none" || district_id.blank?
      end
  end
end
