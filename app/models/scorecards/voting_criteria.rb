# frozen_string_literal: true

module Scorecards
  class VotingCriteria
    attr_reader :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def criterias
      scorecard.voting_indicators.includes(:indicatorable).order(median: :desc).map do |indicator|
        criteria = indicator.as_json
        criteria = assign_rating_info(criteria, indicator)
        criteria["name"] = indicator.indicatorable.name
        criteria
      end
    end

    private
      def assign_rating_info(criteria = {}, indicator)
        VotingIndicator.medians.each do |key, value|
          criteria["#{key}_count"] = scorecard.ratings.select { |rating| rating.voting_indicator_uuid == indicator.uuid && rating.score == value }.length
        end

        criteria
      end
  end
end
