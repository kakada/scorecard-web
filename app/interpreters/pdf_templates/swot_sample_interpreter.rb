# frozen_string_literal: true

module PdfTemplates
  class SwotSampleInterpreter
    def load(field)
      self.send(field.to_sym)
    end

    def result_table
      html = "<table class='table table-bordered'>"
      html += "<thead>#{ build_result_header }</thead>"
      html += "<tbody>#{ build_result_rows }</tbody>"
      html + "</table>"
    end

    private
      def build_result_header
        columns = %w(indicator average_score strength weakness suggested_action)

        headers = columns.map { |col|
          "<th class='text-center'>" + I18n.t("scorecard.#{col}") + "</th>"
        }.join("")

        "<tr>#{headers}</tr>"
      end

      def build_result_rows
        "<tr>#{ build_result_columns }</tr>"
      end

      def build_result_columns
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
  end
end
