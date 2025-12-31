# frozen_string_literal: true

class CalculateVotingResultsWorker
  include Sidekiq::Worker

  def perform(scorecard_id)
    scorecard = Scorecard.find(scorecard_id)

    scorecard.voting_indicators.find_each do |indicator|
      scores = indicator.ratings.pluck(:score)
      median = Ratings::MedianCalculator.new(scores).call

      indicator.update!(median: median)
    end
  end
end
