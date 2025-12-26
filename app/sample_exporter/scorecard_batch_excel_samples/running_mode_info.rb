# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class RunningModeInfo < Base
    private
      def build_headers
        sheet.add_row %w(running_mode_km running_mode_en)
      end

      def build_rows
        sheet.add_row ["ក្រៅបណ្តាញ", "offline"]
        sheet.add_row ["នៅលើបណ្តាញ", "online"]
      end
  end
end
