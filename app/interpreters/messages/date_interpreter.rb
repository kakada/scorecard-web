# frozen_string_literal: true

module Messages
  class DateInterpreter
    def initialize(scorecard)
      @scorecard = scorecard
    end

    def load(field)
      self.send(field.to_sym) if self.respond_to?(field.to_sym)
    end

    def today
      I18n.l(Date.today)
    end
  end
end
