# frozen_string_literal: true

Dir["/app/lib/builders/excel_builders/*.rb"].each { |file| require file }

class ScorecardExcelBuilder
  def initialize(workbook, scorecards)
    @workbook = workbook
    @scorecards = scorecards
  end

  def build
    %w(ScorecardSummary Participant Indicator ProposedIndicator VotingSummary VotingDetail ScorecardResult).each do |klass_name|
      add_worksheet(klass_name)
    end
  end

  private
    def add_worksheet(klass_name)
      model = "ExcelBuilders::#{klass_name}ExcelBuilder".constantize
      sheet_name = klass_name.split(/(?=[A-Z])/).join('_').downcase

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
