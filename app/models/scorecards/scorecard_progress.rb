# frozen_string_literal: true

module Scorecards
  class ScorecardProgress
    attr_reader :scorecards

    def initialize(scorecards = [])
      @scorecards = scorecards
    end

    def group_count
      OpenStruct.new(
        all: scorecards.length,
        planned: scorecards.select { |s| Scorecard.planned_statuses.include?(s.progress) }.length,
        running: scorecards.select(&:running?).length,
        in_review: scorecards.select(&:in_review?).length,
        completed: scorecards.select(&:completed?).length
      )
    end
  end
end
