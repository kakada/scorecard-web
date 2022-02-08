# frozen_string_literal: true

module ExcelBuilders
  class ProposedIndicatorExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:raised_indicators).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.participant_id"),
        I18n.t("excel.indicator_id"),
        I18n.t("excel.seleted_for_implementation")
      ]
    end

    def build_row(scorecard)
      scorecard.raised_indicators.sort_by { |ri| ri.participant_uuid }.each do |raised_indicator|
        sheet.add_row generate_row(raised_indicator, scorecard)
      end
    end

    private
      def generate_row(raised_indicator, scorecard)
        [
          scorecard.uuid,
          raised_indicator.participant_uuid,
          raised_indicator.indicator_uuid,
          raised_indicator.selected?,
        ]
      end
  end
end
