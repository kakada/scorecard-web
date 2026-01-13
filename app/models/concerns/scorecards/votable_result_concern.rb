# frozen_string_literal: true

module Scorecards::VotableResultConcern
  extend ActiveSupport::Concern

  included do
    after_commit :calculate_voting_results, on: :update, if: -> { saved_change_to_progress? && close_voting? }

    def calculate_voting_results
      voting_indicators.includes(:ratings).find_each do |indicator|
        scores = indicator.ratings.map(&:score)
        median = Ratings::MedianCalculator.new(scores).call

        indicator.update_column(:median, median)
      end
    end
  end
end
