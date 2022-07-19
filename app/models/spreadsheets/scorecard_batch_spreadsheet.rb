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

    def import(file_path)
      return unless valid?(file_path)

      spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
        next unless sheet_name.to_s.downcase == "scorecard"

        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row)
        end
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.scorecards_attributes = @scorecards_attributes
      batch.attributes = batch.attributes.merge(batch_params)
      batch
    end

    def process(row)
      facility = program.facilities.find_by(code: parse_string(row["facility_code"])) if row["facility_code"].present?
      commune = Pumi::Commune.find_by_id(parse_string(row["commune_code"])) if row["commune_code"].present?
      primary_school = PrimarySchool.find_by(code: parse_string(row["primary_school_code"])) if row["primary_school_code"].present? && facility.try(:dataset).present?
      local_ngo = program.local_ngos.find_by(code: parse_string(row["local_ngo_code"])) if row["local_ngo_code"].present?
      scorecard_type = parse_string(row["scorecard_type_en"]) if Scorecard.scorecard_types.keys.include? parse_string(row["scorecard_type_en"])

      @scorecards_attributes.push({
        year: row["year"],
        unit_type_id: facility.try(:parent_id),
        facility_id: facility.try(:id),
        scorecard_type: scorecard_type,
        commune_id: commune.try(:id),
        district_id: commune.try(:district_id),
        province_id: commune.try(:province_id),
        primary_school_code: primary_school.try(:id),
        local_ngo_id: local_ngo.try(:id),
        planned_start_date: parse_date(row["planned_start_date"]),
        planned_end_date: parse_date(row["planned_end_date"]),
        program_id: program.id,
        creator_id: @user.id
      })
    end

    private
      def batch_params
        valid_scorecards = batch.scorecards.select { |s| s.valid? }
        {
          total_item: batch.scorecards.length,
          total_valid: valid_scorecards.length,
          total_province: valid_scorecards.pluck(:province_id).uniq.length,
          total_district: valid_scorecards.pluck(:district_id).uniq.length,
          total_commune: valid_scorecards.pluck(:commune_id).uniq.length
        }
      end
  end
end
