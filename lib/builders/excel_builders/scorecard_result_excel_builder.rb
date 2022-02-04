# frozen_string_literal: true

module ExcelBuilders
  class ScorecardResultExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:voting_indicators).find_each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.indicator_id"),
        I18n.t("excel.weakness"),
        I18n.t("excel.strength"),
        I18n.t("excel.suggested_action")
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
          voting_indicator.weakness_indicator_activities.map(&:content).join(";"),
          voting_indicator.strength_indicator_activities.map(&:content).join(";"),
          suggested_actions(voting_indicator)
        ]
      end

      def suggested_actions(voting_indicator)
        data = []
        voting_indicator.suggested_indicator_activities.each do |action|
          content = action.content
          content = "#{content}(selected)" if action.selected?
          data.push(content)
        end
        data.join(";")
      end
  end
end
