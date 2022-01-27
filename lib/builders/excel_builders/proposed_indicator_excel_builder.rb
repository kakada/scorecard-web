# frozen_string_literal: true

module ExcelBuilders
  class ProposedIndicatorExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
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
      scorecard.raised_indicators.find_each do |raised_indicator|
        sheet.add_row generate_row(raised_indicator)
      end
    end

    private
      def generate_row(raised_indicator)
        [
          raised_indicator.scorecard.uuid,
          raised_indicator.participant_uuid,
          raised_indicator.indicator_uuid,
          raised_indicator.selected?,
        ]
      end
  end
end
