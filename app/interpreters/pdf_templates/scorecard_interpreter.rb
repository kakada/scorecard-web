# frozen_string_literal: true

module PdfTemplates
  class ScorecardInterpreter
    attr_reader :scorecard

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

    def facility_name
      str = scorecard.facility_name
      str = "#{str} #{scorecard.primary_school_name}" if scorecard.primary_school_name.present?
      str
    end

    def conducted_date
      return "" unless scorecard.conducted_date.present?

      I18n.l(scorecard.conducted_date)
    end

    def facilitators
      html = scorecard.cafs.map { |caf| "<li>#{caf.name}</li>" }.join("")

      "<ol>#{html}</ol>"
    end

    def scorecard_type
      scorecard.t_scorecard_type
    end

    def conducted_year_ce
      return "" unless scorecard.year.present?

      localize_number(scorecard.year.to_s)
    end

    def conducted_year_be
      return "" unless scorecard.year.present?

      localize_number((scorecard.year + 543).to_s)
    end

    private
      def localize_number(number_string)
        return number_string unless I18n.locale == :km

        khmer_numerals = {
          "0" => "០",
          "1" => "១",
          "2" => "២",
          "3" => "៣",
          "4" => "៤",
          "5" => "៥",
          "6" => "៦",
          "7" => "៧",
          "8" => "៨",
          "9" => "៩"
        }

        number_string.chars.map { |c| khmer_numerals[c] || c }.join
      end
  end
end
