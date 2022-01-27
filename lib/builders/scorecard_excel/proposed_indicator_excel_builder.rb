# frozen_string_literal: true

module ScorecardExcel
  class ProposedIndicatorExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
    end

    def build_header
      sheet.add_row [
        I18n.t("scorecard.id"),
        I18n.t("scorecard.scorecard_id"),
        I18n.t("scorecard.participant_id"),
        I18n.t("scorecard.name"),
        I18n.t("scorecard.tag"),
        I18n.t("scorecard.selected")
      ]
    end

    def build_row(scorecard)
      @scorecard = scorecard
      @scorecard.raised_indicators.find_each do |raised_indicator|
        sheet.add_row generate_row(raised_indicator, scorecard)
      end
    end

    private
      def generate_row(raised_indicator, scorecard)
        [
          raised_indicator.id,
          raised_indicator.scorecard.uuid,
          raised_indicator.participant_uuid,
          raised_indicator.indicator.name,
          raised_indicator.indicator.tag.try(:name),
          is_selected?(raised_indicator),
        ]
      end

      def is_selected?(raised_indicator)
        voting_indicators.select { |vi| vi.indicator_uuid == raised_indicator.indicator_uuid }.present?
      end

      def voting_indicators
        @voting_indicators ||= @scorecard.voting_indicators
      end
  end
end
