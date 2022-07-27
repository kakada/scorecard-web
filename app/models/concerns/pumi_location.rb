# frozen_string_literal: true

module PumiLocation
  extend ActiveSupport::Concern

  included do
    def province
      Pumi::Province.find_by_id(province_id)["name_#{I18n.locale}"]
    end

    def district
      Pumi::District.find_by_id(district_id).try("name_#{I18n.locale}")
    end

    def commune
      Pumi::Commune.find_by_id(commune_id).try("name_#{I18n.locale}")
    end
  end
end
