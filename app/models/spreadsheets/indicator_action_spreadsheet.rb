# frozen_string_literal: true

module Spreadsheets
  class IndicatorActionSpreadsheet < BaseSpreadsheet
    def import(file_path)
      return unless valid?(file_path)

      spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
        rows = sheet.parse(headers: true)
        rows[1..-1].each do |row|
          process(row, sheet_name)
        end
      end
    end

    def process(row, sheet_name)
      return unless row["action_name"].present? && row["indicator_id"].present?

      upsert_indicator_action(row, sheet_name)
    rescue
      Rails.logger.warn "unknown handler for indicator action================: #{row}"
    end

    private
      def upsert_indicator_action(row, sheet_name)
        return unless indicator = Indicator.find_by(uuid: row["indicator_id"]).presence

        code = row["standard_code"].presence || "999_#{SecureRandom.uuid[0..3]}"
        indicator_action = indicator.indicator_actions.find_or_initialize_by(code: code)

        indicator_action.update(name: row["action_name"], kind: sheet_name)
      end
  end
end
