# frozen_string_literal: true

Dir["/app/lib/builders/scorecard_excel/*.rb"].each { |file| require file }

class ScorecardExcelBuilder
  def initialize(workbook, scorecards)
    @workbook = workbook
    @scorecards = scorecards
  end

  def build
    %w(ScorecardSummary Participant ProposedIndicator Voting ScorecardResult).each do |sheet_name|
      add_worksheet(sheet_name)
    end
  end

  private
    def add_worksheet(sheet_name)
      model = "ScorecardExcel::#{sheet_name}ExcelBuilder".constantize

      @workbook.add_worksheet(name: sheet_name) do |sheet|
        builder = model.new(sheet)
        builder.build_header

        @scorecards.each do |scorecard|
          builder.build_row(scorecard)
        end
      end

      rescue
        Rails.logger.warn "Unknown ExcelBuilder model #{model}"
    end
end
