# frozen_string_literal: true

module ScorecardJson
  class VotingIndicatorJsonBuilder
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
          {
            name: vi.indicatorable.name,
            tag: vi.indicatorable.tag_name,
            median: VotingIndicator.medians[vi.median],
            participants: build_participants(vi)
          }
        end
      end

      def build_participants(voting_indicator)
        {
          total: voting_indicator.ratings.length,
          profiles: build_profiles(voting_indicator)
        }
      end

      def build_profiles(voting_indicator)
        profiles = [ { type: "female", avg_score: get_avg_score(voting_indicator, "female") } ]

        %w(disability minority poor_card youth).each do |type|
          profiles << { type: type, avg_score: get_avg_score(voting_indicator, type) }
        end

        profiles
      end

      def get_avg_score(voting_indicator, type = "female")
        ratings = voting_indicator.ratings.select { |rating|
          if type == "female"
            !!rating.participant && rating.participant.gender == "female"
          else
            !!rating.participant && rating.participant[type]
          end
        }

        ratings.collect(&:score).mean.to_f.round_up_half
      end

      def voting_indicators
        @voting_indicators ||= scorecard.voting_indicators.includes(:indicatorable, ratings: :participant).order(:display_order)
      end
  end
end
