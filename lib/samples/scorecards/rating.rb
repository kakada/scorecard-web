# frozen_string_literal: true

module Samples
  module Scorecards
    class Rating
      def self.load(scorecard)
        scorecard.number_of_participant.to_i.times do |i|
          participant = scorecard.participants[i]

          scorecard.voting_indicators.each do |indi|
            scorecard.ratings.create(
              voting_indicator_uuid: indi.uuid,
              score: rand(1..5),
              participant_uuid: participant.try(:uuid)
            )
          end
        end

        update_voting_indicator_median(scorecard)
      end

      private
        def self.update_voting_indicator_median(scorecard)
          scorecard.voting_indicators.each do |indi|
            ratings = ::Rating.where(voting_indicator_uuid: indi.uuid).pluck(:score)
            indi.update(median: ratings.median.ceil)
          end
        end
    end
  end
end
