# frozen_string_literal: true

module Spreadsheets
  module CafBatches
    class CafSpreadsheet
      attr_reader :caf

      def initialize(caf)
        @caf = caf
      end

      def process(row)
        commune = Pumi::Commune.find_by_id(row["based_commune_code"])

        caf.attributes = {
          name: row["name"],
          sex: row["gender"],
          date_of_birth: row["date_of_birth"],
          tel: row["phone_number"],
          commune_id: commune.try(:id),
          district_id: commune.try(:district_id),
          province_id: commune.try(:province_id),
          educational_background: EducationalBackground.find_by(code: row["educational_background_code"]),
          scorecard_knowledges: ScorecardKnowledge.where(code: row["scorecard_knowledge_codes"].to_s.split(","))
        }

        caf
      end
    end
  end
end
