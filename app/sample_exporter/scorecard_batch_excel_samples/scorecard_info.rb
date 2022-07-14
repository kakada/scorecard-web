# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class ScorecardInfo < Base
    private
      def build_headers
        sheet.add_row %w(year facility_code scorecard_type_en commune_code  primary_school_code local_ngo_code planned_start_date planned_end_date)
      end

      def build_rows
        facility = program.facilities.only_children.where(dataset: nil).sample

        row = [
          Date.today.year,
          facility.try(:code) || "HC",
          Scorecard.scorecard_types.keys.sample,
          "010201",
          nil,
          program.local_ngos.sample.try(:code),
          Date.today.strftime("%Y-%m-%d"),
          Date.tomorrow.strftime("%Y-%m-%d")
        ]

        sheet.add_row row, types: [:integer, :string, :string, :string, :string, :string]
      end
  end
end
