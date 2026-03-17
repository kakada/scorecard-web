# frozen_string_literal: true

module Scorecards
  class ScorecardProgress
    attr_reader :scorecards

    def initialize(scorecards = [])
      @scorecards = scorecards
    end

    def group_count
      OpenStruct.new(
        all: scorecards.count,
        planned: scorecards.count { |s| Scorecard::PLANNED_STATUSES.include?(s.progress) },
        running: scorecards.count { |s| Scorecard::RUNNING_STATUSES.include?(s.progress) },
        in_review: scorecards.count(&:in_review?),
        completed: scorecards.count(&:completed?)
      )
    end
  end
end
