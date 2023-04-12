# frozen_string_literal: true

module Spreadsheets
  module LocalNgoBatches
    class LocalNgoSpreadsheet
      attr_reader :program, :row

      def initialize(program, row)
        @program = program
        @row = row
      end

      def process
        LocalNgo.new(
          name: row["name"],
          commune_id: commune.try(:id),
          district_id: commune.try(:district_id),
          province_id: commune.try(:province_id),
          target_province_ids: row["target_province_ids"],
          target_provinces: row["target_province_ids"],
          website_url: row["website"],
          program_id: program.id
        )
      end

      private
        def commune
          @commune ||= Pumi::Commune.find_by_id(row["commune_id"])
        end
    end
  end
end
