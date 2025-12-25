# frozen_string_literal: true

module Spreadsheets
  class ScorecardBatchSpreadsheet < BaseSpreadsheet
    attr_reader :program, :batch

    def initialize(user)
      @program = user.program
      @user = user
      @batch = program.scorecard_batches.new
      @scorecards_attributes = []
    end

    def import(file)
      return unless valid?(file)

      spreadsheet(file).each_with_pagename do |sheet_name, sheet|
        next unless sheet_name.to_s.downcase == "scorecard"

        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row)
        end
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.scorecards_attributes = @scorecards_attributes
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      local_ngo = program.local_ngos.find_by(code: parse_string(row["local_ngo_code"]))
      facility = program.facilities.find_by(code: parse_string(row["facility_code"]))
      scorecard_type = parse_string(row["scorecard_type_en"]) if Scorecard.scorecard_types.keys.include? parse_string(row["scorecard_type_en"])
      running_mode = Scorecard.running_modes.keys.include?(parse_string(row["running_mode_en"])) ? parse_string(row["running_mode_en"]) : "offline"

      @scorecards_attributes.push(
        {
          year: row["year"],
          unit_type_id: facility.try(:parent_id),
          facility_id: facility.try(:id),
          scorecard_type: scorecard_type,
          running_mode: running_mode,
          local_ngo_id: local_ngo.try(:id),
          planned_start_date: parse_date(row["planned_start_date"]),
          planned_end_date: parse_date(row["planned_end_date"]),
          program_id: program.id,
          creator_id: @user.id,
          dataset_id: dataset(facility, row).try(:id)
        }.merge(location_params(row))
      )
    end

    private
      def batch_params(file)
        valid_scorecards = batch.scorecards.select { |s| s.valid? }
        {
          total_item: batch.scorecards.length,
          total_valid: valid_scorecards.length,
          total_province: valid_scorecards.pluck(:province_id).uniq.length,
          total_district: valid_scorecards.pluck(:district_id).uniq.length,
          total_commune: valid_scorecards.pluck(:commune_id).uniq.length,
          filename: file.original_filename
        }
      end

      def location_params(row)
        location_code = row["commune_code"] || row["location_code"]

        return {} unless location_code.present?

        province = Pumi::Province.find_by_id(location_code[0..1])
        district = Pumi::District.find_by_id(location_code[0..3])
        commune = Pumi::Commune.find_by_id(location_code[0..5])

        {
          province_id: province.try(:id),
          district_id: district.try(:id),
          commune_id: commune.try(:id)
        }
      end

      def dataset(facility, row)
        return nil if facility.nil? || facility.category.nil?

        dataset_code = program.dataset_categories.map { |category| row[category.column_code_name] }.compact.first

        facility.category.datasets.find_by(code: parse_string(dataset_code))
      end
  end
end
