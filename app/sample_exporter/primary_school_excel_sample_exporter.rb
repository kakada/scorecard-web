# frozen_string_literal: true

class PrimarySchoolExcelSampleExporter
  attr_accessor :workbook, :primary_schools, :provinces

  def initialize(workbook, primary_schools)
    @workbook = workbook
    @primary_schools = primary_schools

    province_ids = primary_schools.pluck(:province_id).uniq.sort
    @provinces = Pumi::Province.all.select { |province| province_ids.include? province.id }
  end

  def build
    provinces.each do |province|
      add_worksheet(province)
    end
  end

  private
    def add_worksheet(province)
      schools = primary_schools.select { |school| school.province_id == province.id }

      workbook.add_worksheet(name: province.name_km) do |sheet|
        PrimarySchoolExcelSamples::PrimarySchoolInfo.new(sheet, schools.sort_by(&:commune_id)).build
      end
    end
end
