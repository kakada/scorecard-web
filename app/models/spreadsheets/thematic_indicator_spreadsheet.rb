# frozen_string_literal: true

module Spreadsheets
  class ThematicIndicatorSpreadsheet < BaseSpreadsheet
    def process(row)
      return unless row["thematic_code"].present?

      update_indicator(row)
    rescue
      Rails.logger.warn "unknown handler for thematic================: #{row}"
    end

    private
      def update_indicator(row)
        thematic = Thematic.find_by(code: row["thematic_code"])
        indicator = Indicator.find_by(uuid: row["indicator_id"])

        return unless thematic.present? && indicator.present?

        indicator.update(thematic_id: thematic.id)
      end
  end
end
