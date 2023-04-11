# frozen_string_literal: true

module Spreadsheets
  class LocalNgoBatchSpreadsheet < BaseSpreadsheet
    attr_reader :program, :batch

    def initialize(user)
      @program = user.program
      @batch = program.local_ngo_batches.new
      @importing_local_ngos = []
    end

    def import(file)
      return unless valid?(file)

      spreadsheet(file).each_with_pagename do |sheet_name, sheet|
        next unless sheet_name.to_s.downcase == "localngo"

        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row)
        end
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.importing_local_ngos = @importing_local_ngos
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      @importing_local_ngos.push(
        Spreadsheets::LocalNgoBatches::LocalNgoSpreadsheet.new(program, row).process
      )
    end

    private
      def batch_params(file)
        valid_local_ngos = batch.importing_local_ngos.select { |s| s.valid? }
        {
          total_count: batch.importing_local_ngos.length,
          valid_count: valid_local_ngos.length,
          reference: file
        }
      end
  end
end
