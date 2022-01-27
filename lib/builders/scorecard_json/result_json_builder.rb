# frozen_string_literal: true

module ScorecardJson
  class ResultJsonBuilder
    attr_accessor :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def build
      {
        priority_indicators: {
          total: scorecard.voting_indicators.length,
          suggested_indicators: build_indicators
        }
      }
    end

    private
      def build_indicators
        scorecard.voting_indicators.order(:display_order).map do |vi|
          {
            name: vi.indicator.name,
            tag: vi.indicator.tag_name,
            count: vi.suggested_action.length,
            selected_actions: vi.suggested_action.map { |action| return { description: action } }
          }
        end
      end
  end
end
