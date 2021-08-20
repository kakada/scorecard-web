# frozen_string_literal: true

module Sample
  class EducationalBackground < ::Sample::Base
    def self.load
      xlsx = Roo::Spreadsheet.open(file_path("educational_backgrounds.xlsx"))
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        rows[1..-1].each_with_index do |row, index|
          next unless row["code"].present?

          ed = ::EducationalBackground.find_or_initialize_by(code: row["code"])
          ed.update(name: row["name"])
        end
      end
    end
  end
end
