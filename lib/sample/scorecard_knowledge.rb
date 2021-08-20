# frozen_string_literal: true

module Sample
  class ScorecardKnowledge < ::Sample::Base
    def self.load
      xlsx = Roo::Spreadsheet.open(file_path("scorecard_knowledges.xlsx"))
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        rows[1..-1].each_with_index do |row, index|
          next unless row["code"].present?

          sk = ::ScorecardKnowledge.find_or_create_by(code: row["code"])
          sk.update(name: row["name"])
        end
      end
    end
  end
end
