# frozen_string_literal: true

module Ratings
  class MedianCalculator
    def initialize(scores)
      @scores = Array(scores).compact.map(&:to_f).sort
    end

    def call
      return nil if @scores.empty?

      mid = @scores.length / 2

      @scores.length.odd? ? @scores[mid] : (@scores[mid - 1] + @scores[mid]) / 2.0
    end
  end
end
