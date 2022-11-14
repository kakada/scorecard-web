# frozen_string_literal: true

class DatasetExcelSampleExporter
  attr_accessor :workbook, :datasets, :category

  def initialize(workbook, datasets, category)
    @workbook = workbook
    @datasets = datasets.sort_by(&:commune_id)
    @category = category
  end

  def build
    workbook.add_worksheet(name: "REF - #{category.name_en}") do |sheet|
      add_worksheet(sheet)
    end
  end

  private
    def add_worksheet(sheet)
      build_headers(sheet)
      build_rows(sheet)
    end

    def build_headers(sheet)
      sheet.add_row ["Province", "District", "Commune", "Code", "#{category.name_en} name in English", "#{category.name_en} name in Khmer"]
    end

    def build_rows(sheet)
      datasets.each do |s|
        commune = Pumi::Commune.find_by_id(s.commune_id)
        district = Pumi::District.find_by_id(s.district_id)
        province = Pumi::Province.find_by_id(s.province_id)

        sheet.add_row [
          "#{province.try(:name_km)} (#{province.try(:id)})",
          "#{district.try(:name_km)} (#{district.try(:id)})",
          "#{commune.try(:name_km)} (#{commune.try(:id)})",
          s.code,
          s.name_en,
          s.name_km
        ], types: [:string, :string, :string, :string]
      end
    end
end
