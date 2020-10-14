# frozen_string_literal: true

module Sample
  class Indicator
    def self.load
      path = Rails.root.join("lib", "sample", "assets", "csv", "indicators.xlsx").to_s

      xlsx = Roo::Spreadsheet.open(path)
      xlsx.each_with_pagename do |page_name, sheet|
        sheet = sheet.parse(headers: true)
        category = ::Category.find_by(name: page_name)

        create_indicators(sheet, category)
      end
    end

    private
      def self.create_indicators(sheet, category)
        return if category.nil?

        sheet.each_with_index do |row, index|
          next if index == 0

          category.indicators.create(name: row['name'], tag: row['tag'])
        end
      end
  end
end
