# frozen_string_literal: true

class Spreadsheets::PrimarySchoolSpreadsheet
  attr_reader :program

  def import(file_path)
    return if file_path.blank?

    spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
      rows = sheet.parse(headers: true)
      rows[1..-1].each do |row|
        process(row)
      end
    rescue
      Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
    end
  end

  private
    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end

    def process(row)
      commune = get_commune(row)
      return if commune.blank?

      school = ::PrimarySchool.find_or_initialize_by(code: row["code"].strip)
      school.code ||= build_school_code(commune)
      school.name_km = row["name_km"]
      school.name_en = row["name_en"] || row["name_km"]
      school.commune_id ||= commune.id
      school.district_id ||= commune.district_id
      school.province_id ||= commune.province_id
      school.save
    end

    def get_commune(row)
      return if row["commune"].blank?

      if communes = Pumi::Commune.where(name_en: row["commune"].strip).presence
        communes.length == 1 ? communes.first : communes.select { |c| c.district.name_en == row["district"].strip }[0]
      end
    end

    def build_school_code(commune)
      num = ::PrimarySchool.where(commune_id: commune.id).length + 1
      "#{commune.id}_#{num}"
    end
end
