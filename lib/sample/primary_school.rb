# frozen_string_literal: true

require "csv"

module Sample
  class PrimarySchool
    def self.load
      file_path = Rails.root.join("lib", "sample", "assets", "csv", "primary_schools.xlsx").to_s

      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      xlsx = Roo::Spreadsheet.open(file_path)
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        rows[1..-1].each_with_index do |row, index|
          commune = get_commune(row)
          next unless row["school_name_km"].present? && commune.present?

          school = ::PrimarySchool.find_or_initialize_by(name_km: row["school_name_km"].strip, commune_id: commune.id)
          school.name_en = row["school_name_en"] || school.name_km
          school.code ||= build_school_code(commune)
          school.save
        end
      end
    end

    private
      def self.get_commune(row)
        return if row["commune"].blank?

        if communes = Pumi::Commune.where(name_en: row["commune"].strip).presence
          communes.length == 1 ? communes.first : communes.select { |c| c.district.name_en == row["district"].strip }[0]
        end
      end

      def self.build_school_code(commune)
        num = ::PrimarySchool.where(commune_id: commune.id).length + 1
        "#{commune.id}_#{num}"
      end
  end
end
