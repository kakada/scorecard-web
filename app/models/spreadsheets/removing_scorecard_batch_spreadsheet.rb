# frozen_string_literal: true

module Spreadsheets
  class RemovingScorecardBatchSpreadsheet < BaseSpreadsheet
    attr_reader :program, :batch

    def initialize(user)
      @program = user.program
      @batch = program.removing_scorecard_batches.new
      @removing_scorecards = []
    end

    def import(file)
      return unless valid?(file)

      spreadsheet(file).each_with_pagename do |sheet_name, sheet|
        next unless sheet_name.to_s.downcase == "removing_scorecard"

        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row)
        end
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.removing_scorecards = @removing_scorecards
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      @removing_scorecards.push(
        Spreadsheets::RemovingScorecardBatches::ScorecardSpreadsheet.new(program, row).process
      )
    end

    private
      def batch_params(file)
        valid_removing_scorecards = batch.removing_scorecards.select { |s| s.valid? }
        {
          total_count: batch.removing_scorecards.length,
          valid_count: valid_removing_scorecards.length,
          reference: file
        }
      end
  end
end
