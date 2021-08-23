# frozen_string_literal: true

module PdfTemplates
  class ScorecardSampleInterpreter
    def load(field)
      if self.respond_to?(field.to_sym)
        self.send(field.to_sym)
      else
        "#{fill_in_value}"
      end
    end

    def facilitators
      html = [1, 2].map {|caf| "<li>#{fill_in_value}</li>"}.join("")

      "<ol>#{html}</ol>"
    end

    private
      def fill_in_value
        "&lt;#{ I18n.t('shared.fill_in') }&gt;"
      end
  end
end
