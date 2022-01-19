# frozen_string_literal: true

module ScorecardExcel
  class VotingExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
    end

    def build_header
      sheet.add_row [
        I18n.t("scorecard.id"),
        I18n.t("scorecard.scorecard_id"),
        I18n.t("scorecard.proposed_indicator_id"),
        I18n.t("scorecard.score")
      ]
    end

    def build_row(scorecard)
      @scorecard = scorecard
      @scorecard.voting_indicators.find_each do |vi|
        sheet.add_row generate_row(vi, scorecard)
      end
    end

    private
      def generate_row(voting_indicator, scorecard)
        [
          voting_indicator.id,
          voting_indicator.scorecard.uuid,
          raised_indicator_id(voting_indicator),
          VotingIndicator.medians[voting_indicator.median]
        ]
      end

      def raised_indicator_id(voting_indicator)
        raised_indicators.select { |ri| ri.indicatorable == voting_indicator.indicatorable }.first.try(:id)
      end

      def raised_indicators
        @raised_indicators ||= @scorecard.raised_indicators
      end
  end
end
