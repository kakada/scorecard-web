# frozen_string_literal: true

module Samples
  class EducationalBackground < Base
    def self.load
      xlsx = Roo::Spreadsheet.open(file_path("educational_backgrounds.xlsx"))
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        rows[1..-1].each_with_index do |row, index|
          next unless row["code"].present?

          edu = ::EducationalBackground.find_or_initialize_by(code: row["code"])
          edu.update(name_en: row["name_en"], name_km: row["name_km"])
        end
      end
    end
  end
end
