# frozen_string_literal: true

class PrimarySchoolJsonBuilder
  attr_accessor :primary_school

  def initialize(primary_school)
    @primary_school = primary_school
  end

  def build
    {
      school_code: primary_school.code,
      school_name_en: primary_school.name_en,
      school_name_km: primary_school.name_km,
      commune_code: primary_school.commune_id,
      district_code: primary_school.district_id,
      province_code: primary_school.province_id
    }
  end
end
