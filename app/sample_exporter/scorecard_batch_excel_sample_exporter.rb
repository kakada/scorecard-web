# frozen_string_literal: true

class ScorecardBatchExcelSampleExporter
  def initialize(workbook, program)
    @workbook = workbook
    @program = program
  end

  def build
    sheets = [
      { name: "Scorecard", klass_name: "ScorecardInfo" },
      { name: "REF - Facility", klass_name: "FacilityInfo" },
      { name: "REF - Scorecard type", klass_name: "ScorecardTypeInfo" },
      { name: "REF - Local NGOs", klass_name: "LocalNgoInfo" }
    ]

    sheets.each do |sheet|
      add_worksheet(sheet)
    end
  end

  private
    def add_worksheet(sheet)
      klass = "ScorecardBatchExcelSamples::#{sheet[:klass_name]}".constantize

      @workbook.add_worksheet(name: sheet[:name]) do |wsheet|
        klass.new(wsheet, @program).build
      end

      rescue
        Rails.logger.warn "Unknown ExcelBuilder model #{klass}"
    end
end
