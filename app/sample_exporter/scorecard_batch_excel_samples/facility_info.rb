# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class FacilityInfo < Base
    private
      def build_headers
        sheet.add_row %w(facility_name facility_code)
      end

      def build_rows
        program.facilities.only_children.each do |facility|
          sheet.add_row [facility.name_km, facility.code]
        end
      end
  end
end
