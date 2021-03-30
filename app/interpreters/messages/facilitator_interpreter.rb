# frozen_string_literal: true

module Messages
  class FacilitatorInterpreter
    def initialize(scorecard)
      @scorecard = scorecard
    end

    def load(field)
      return "" if @scorecard.facilitators.first.nil?

      @scorecard.facilitators.first.caf.name
    end
  end
end
