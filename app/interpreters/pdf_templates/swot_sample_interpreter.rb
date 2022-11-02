# frozen_string_literal: true

module PdfTemplates
  class SwotSampleInterpreter
    def load(field)
      self.send(field.to_sym)
    end

    def result_table
      "<table class='table table-bordered'>" +
        "<thead>#{ render_head }</thead>" +
        "<tbody>#{ render_body }</tbody>" +
      "</table>" +
      render_shortcut_note
    end

    private
      def render_head
        columns = %w(indicator average_score strength weakness suggested_action)

        headers = columns.map { |col|
          "<th class='text-center'>" + I18n.t("scorecard.#{col}") + "</th>"
        }.join("")

        "<tr>#{headers}</tr>"
      end

      def render_body
        "<tr>#{ render_each_row }</tr>"
      end

      def render_each_row
        columns = %w(name median strength weakness suggested_action)
        columns.map do |field|
          field_value = VotingIndicator.new[field]
          value = field_value.kind_of?(Array) ? build_list : fill_in_value

          "<td>#{value}</td>"
        end.join("")
      end

      def build_list
        "<ul><li>#{ fill_in_value }</li></ul>"
      end

      def fill_in_value
        "&lt;#{ I18n.t('shared.fill_in') }&gt;"
      end

      def render_shortcut_note
        "<div>" +
          "#{I18n.t('scorecard.note')}: " +
          participant_profiles.map { |profile| I18n.t("scorecard.#{profile}_shortcut") + ": " + I18n.t("scorecard.#{profile}_fullword") }.join(", ") +
        "</div>"
      end

      def participant_profiles
        @participant_profiles ||= %w(female minority disability poor_card youth)
      end
  end
end
