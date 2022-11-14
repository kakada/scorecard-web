# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class ScorecardInfo < Base
    private
      def build_headers
        row = ["year", "facility_code", "scorecard_type_en", "location_code"]
        row.concat program.dataset_categories.map { |category| category.column_code_name }
        row.concat ["local_ngo_code", "planned_start_date", "planned_end_date"]

        sheet.add_row row
      end

      def build_rows
        facility = program.facilities.only_children.where.not(category_id: nil).sample

        row = [ Date.today.year, facility.try(:code) || "HC", Scorecard.scorecard_types.keys.sample, "010201" ]
        row.concat datasets(facility)
        row.concat [program.local_ngos.sample.try(:code), Date.today.strftime("%Y-%m-%d"), Date.tomorrow.strftime("%Y-%m-%d")]

        sheet.add_row row, types: [:integer, :string, :string, :string, :string, :string]
      end

      def datasets(facility)
        return [] unless program.dataset_categories.present?

        dataset = facility.category.datasets.sample

        program.dataset_categories.map do |category|
          facility.category.column_code_name == category.column_code_name ? dataset.code : nil
        end
      end
  end
end
