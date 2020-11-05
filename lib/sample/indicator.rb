# frozen_string_literal: true

module Sample
  class Indicator
    def self.load
      path = Rails.root.join("lib", "sample", "assets", "csv", "indicators.xlsx").to_s

      xlsx = Roo::Spreadsheet.open(path)
      xlsx.each_with_pagename do |page_name, sheet|
        sheet = sheet.parse(headers: true)
        facility = ::Facility.find_by(name: page_name)

        create_indicators(sheet, facility)
      end
    end

    private
      def self.create_indicators(sheet, facility)
        return if facility.nil?

        sheet.each_with_index do |row, index|
          next if index == 0

          facility.indicators.create(name: row["name"], tag: row["tag"])
        end
      end
  end
end
