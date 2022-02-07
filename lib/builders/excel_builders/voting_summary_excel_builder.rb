# frozen_string_literal: true

module ExcelBuilders
  class VotingSummaryExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:voting_indicators).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.indicator_id"),
        I18n.t("excel.average_score")
      ]
    end

    def build_row(scorecard)
      scorecard.voting_indicators.find_each do |vi|
        sheet.add_row generate_row(vi)
      end
    end

    private
      def generate_row(voting_indicator)
        [
          voting_indicator.scorecard.uuid,
          voting_indicator.indicator_uuid,
          VotingIndicator.medians[voting_indicator.median]
        ]
      end
  end
end
