# frozen_string_literal: true

module Messages
  class ScorecardInterpreter
    attr_accessor :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def load(field)
      if self.respond_to?(field.to_sym)
        self.send(field.to_sym)
      else
        scorecard.send(field.to_sym)
      end
    end

    def planned_start_date
      I18n.l(scorecard.planned_start_date)
    end

    def planned_end_date
      I18n.l(scorecard.planned_end_date)
    end

    def code
      scorecard.uuid
    end

    def url
      link = "#{ENV['HOST_URL']}/scorecards/#{scorecard.id}"
      "<a href='#{link}'>#{link}</a>"
    end

    def facility
      "#{scorecard.unit_type.name} > #{scorecard.facility_name}"
    end

    def scorecard_type
      I18n.t("scorecard.#{scorecard.scorecard_type}")
    end
  end
end
