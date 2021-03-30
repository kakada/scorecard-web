# frozen_string_literal: true

module Messages
  class ScorecardInterpreter
    def initialize(scorecard)
      @scorecard = scorecard
    end

    def load(field)
      if self.respond_to?(field.to_sym)
        self.send(field.to_sym)
      else
        @scorecard.send(field.to_sym)
      end
    end

    def planned_start_date
      return if @scorecard.planned_start_date.nil?
      I18n.l(@scorecard.planned_start_date)
    end

    def planned_end_date
      return if @scorecard.planned_end_date.nil?
      I18n.l(@scorecard.planned_end_date)
    end
  end
end
