# frozen_string_literal: true

module Sample
  class Indicator
    def self.load
      path = Rails.root.join("lib", "sample", "assets", "csv", "indicators.xlsx").to_s

      xlsx = Roo::Spreadsheet.open(path)
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        facility = ::Facility.find_by(name_en: page_name)

        create_indicators(rows, facility)
      end
    end

    private
      def self.create_indicators(rows, facility)
        return if facility.nil?

        rows[1..-1].each_with_index do |row, index|
          facility.indicators.create(name: row["name"], tag_attributes: { name: row["tag"] })
        end
      end
  end
end
