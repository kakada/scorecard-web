# frozen_string_literal: true

module PdfTemplates
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

    def conducted_date
      return "" unless @scorecard.conducted_date.present?

      I18n.l(@scorecard.conducted_date)
    end

    def facilitators
      html = @scorecard.cafs.map {|caf| "<li>#{caf.name}</li>"}.join("")

      "<ol>#{html}</ol>"
    end
  end
end
