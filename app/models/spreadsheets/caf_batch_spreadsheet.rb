# frozen_string_literal: true

module Spreadsheets
  class CafBatchSpreadsheet < BaseSpreadsheet
    attr_reader :local_ngo, :batch

    def initialize(local_ngo)
      @local_ngo = local_ngo
      @batch = CafBatch.new
      @rows = []
    end

    def import(file)
      return unless valid?(file)

      spreadsheet(file).each_with_pagename do |sheet_name, sheet|
        next unless sheet_name.downcase == "caf"

        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row)
        end
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.importing_cafs = importing_cafs
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end

    def process(row)
      @rows.push(row)
    end

    private
      def batch_params(file)
        cafs = batch.importing_cafs
                    .select { |im| im.caf.valid? }
                    .map { |im| im.caf }
        {
          total_count: batch.importing_cafs.length,
          valid_count: cafs.length,
          new_count: cafs.select { |f| f.new_record? }.length,
          province_count: cafs.pluck(:province_id).uniq.length,
          reference: file
        }
      end

      def importing_cafs
        ids = @rows.map { |r| r["id"] }
        cafs = local_ngo.cafs.where(id: ids).includes(:scorecard_knowledges)

        @rows.map do |row|
          caf = cafs.select { |f| f.id == row["id"].to_i }.first || local_ngo.cafs.new

          batch.importing_cafs.new(caf: Spreadsheets::CafBatches::CafSpreadsheet.new(caf).process(row))
        end
      end
  end
end
