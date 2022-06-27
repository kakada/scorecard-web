# frozen_string_literal: true

class Spreadsheets::PrimarySchoolSpreadsheet
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

  def process(row)
    commune = get_commune(row)
    school = ::PrimarySchool.find_or_initialize_by(code: row["school_code"].to_s.strip)
    school.code = school.code.presence || build_school_code(commune)
    school.name_km = row["school_name_km"]
    school.name_en = row["school_name_en"] || row["school_name_km"]
    school.commune_id ||= commune.id
    school.district_id ||= commune.district_id
    school.province_id ||= commune.province_id
    school.save
  rescue
    Rails.logger.warn "unknown handler for primary school================: #{row}"
  end

  private
    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end

    def get_commune(row)
      return nil if row["commune_code"].blank?

      Pumi::Commune.where(id: row["commune_code"].strip).first
    end

    def build_school_code(commune)
      num = ::PrimarySchool.where(commune_id: commune.id).length + 1
      "#{commune.id}_#{num}"
    end
end
