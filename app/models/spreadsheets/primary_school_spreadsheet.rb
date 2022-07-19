# frozen_string_literal: true

class Spreadsheets::PrimarySchoolSpreadsheet < Spreadsheets::BaseSpreadsheet
  def process(row)
    commune = get_commune(row)
    return if commune.nil?

    school = ::PrimarySchool.find_or_initialize_by(code: row["school_code"].to_s.strip)
    school.code = school.code.presence || build_school_code(commune)
    school.name_km = row["school_name_km"]
    school.name_en = row["school_name_en"] || row["school_name_km"]
    school.commune_id ||= commune.id
    school.district_id ||= commune.district_id
    school.province_id ||= commune.province_id
    school.save
  end

  private
    def get_commune(row)
      return nil if row["commune_code"].blank?

      Pumi::Commune.where(id: parse_string(row["commune_code"])).first
    end

    def build_school_code(commune)
      num = ::PrimarySchool.where(commune_id: commune.id).length + 1
      "#{commune.id}_#{num}"
    end
end
