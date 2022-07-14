# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class LocalNgoInfo < Base
    private
      def build_headers
        sheet.add_row %w(local_ngo_name local_ngo_code)
      end

      def build_rows
        program.local_ngos.each do |lngo|
          sheet.add_row [lngo.name, lngo.code], types: [:string, :string]
        end
      end
  end
end
