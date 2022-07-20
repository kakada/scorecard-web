# frozen_string_literal: true

module PrimarySchoolExcelSamples
  class PrimarySchoolInfo
    attr_accessor :sheet, :schools

    def initialize(sheet, schools)
      @sheet = sheet
      @schools = schools
    end

    def build
      build_headers
      build_rows
    end

    private
      def build_headers
        sheet.add_row %w(district commune commune_code school_code school_name_en school_name_km)
      end

      def build_rows
        schools.each do |s|
          commune = Pumi::Commune.find_by_id(s.commune_id)
          sheet.add_row [ commune.district.name_km, commune.name_km, commune.id, s.code, s.name_en, s.name_km], types: [:string, :string, :string, :string]
        end
      end
  end
end
