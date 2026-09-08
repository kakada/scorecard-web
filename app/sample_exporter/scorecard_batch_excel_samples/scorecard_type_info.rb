# frozen_string_literal: true

module ScorecardBatchExcelSamples
  class ScorecardTypeInfo < Base
    private
      def build_headers
        sheet.add_row %w(scorecard_type_km scorecard_type_en)
      end

      def build_rows
        sheet.add_row %w(អង្គភាពផ្តល់សេវា self_assessment)
        sheet.add_row %w(ប្រជាពលរដ្ឋ community_scorecard)
        sheet.add_row [ "ប័ណ្ណដាក់ពិន្ទុ(វាយតម្លៃខ្លួនឯង + សហគមន៍)", "combined_scorecard" ]
      end
  end
end
