# frozen_string_literal: true

module Scorecards
  class VotingCriteria
    attr_reader :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def criterias
      scorecard.voting_indicators.includes(:indicator, ratings: :participant).order(:display_order).map do |vi|
        criteria = vi.as_json
        criteria = assign_rating_info(criteria, vi)
        criteria = assign_participant_info(criteria, vi)
        criteria["name"] = vi.indicator.name
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

      def assign_participant_info(criteria = {}, indicator)
        ratings = indicator.ratings.select { |rating| !!rating.participant && rating.participant.gender == "female" }
        criteria["female_median_score"] = ratings.collect(&:score).mean.to_f.round_up_half

        %w(minority disability poor_card youth).each do |field|
          ratings = indicator.ratings.select { |rating| !!rating.participant && rating.participant[field] }
          criteria["#{field}_average_score"] = ratings.collect(&:score).mean.to_f.round_up_half
        end

        criteria
      end
  end
end
