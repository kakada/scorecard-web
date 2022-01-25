# frozen_string_literal: true

module ScorecardJson
  class IndicatorDevelopmentJsonBuilder
    attr_accessor :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def build
      {
        total: voting_indicators.length,
        indicators: build_indicators
      }
    end

    private
      def build_indicators
        voting_indicators.map do |vi|
          { name: vi.indicator.name, tag: vi.indicator.tag_name }
        end
      end

      def voting_indicators
        @voting_indicators ||= scorecard.voting_indicators.order(:display_order).includes(:indicator)
      end
  end
end
