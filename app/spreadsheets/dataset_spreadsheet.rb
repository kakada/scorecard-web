# frozen_string_literal: true

class DatasetSpreadsheet
  attr_reader :program

  def initialize(category)
    @category =  category
  end

  def import(file_path)
    return if file_path.blank?

    spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
      rows = sheet.parse(headers: true)
      rows[1..-1].each do |row|
        process(row)
      end
    rescue StandardError
      Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
    end
  end

  def process(row)
    location = get_location(row)
    dataset = @category.datasets.find_or_initialize_by(code: row["code"].to_s.strip.presence)
    dataset.code ||= build_code(location.id)
    dataset.name_km = row["name_km"]
    dataset.name_en = row["name_en"] || row["name_km"]
    dataset.commune_id ||= location.id[0..5] if location.id.length >= 6
    dataset.district_id ||= location.id[0..3] if location.id.length >= 4
    dataset.province_id ||= location.id[0..1] if location.id.length >= 2
    dataset.save
  rescue StandardError
    Rails.logger.warn "unknown handler for dataset================: #{row}"
  end

  private
    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end

    def get_location_id(row)
      return nil if row["location_id"].blank?

      id = row["location_id"].strip
      id = sprintf("%0#{id.length + 1}d", id) if id.length.modulo(2) > 0
      id
    end

    def get_location(row)
      id = get_location_id(row)
      kind = Location.location_kind(id)

      "Pumi::#{kind.titlecase}".constantize.find_by_id(id)
    end

    def build_code(location_id)
      kind = Location.location_kind(location_id)
      num = @category.datasets.where("#{kind}_id": location_id).length + 1

      "#{location_id}_#{@category.id}_#{num}"
    end
end
