# frozen_string_literal: true

module Spreadsheets
  class ThematicSpreadsheet < BaseSpreadsheet
    def process(row)
      thematic = Thematic.find_or_initialize_by(code: row["code"])
      thematic.update(name: row["name"], description: row["description"])
    rescue
      Rails.logger.warn "unknown handler for thematic================: #{row}"
    end
  end
end
