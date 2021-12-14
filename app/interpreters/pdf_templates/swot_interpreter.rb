# frozen_string_literal: true

module PdfTemplates
  class SwotInterpreter
    def initialize(scorecard)
      @scorecard = scorecard
    end

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
        voting_criterias = Scorecards::VotingCriteria.new(@scorecard).criterias
        voting_criterias.map { |indicator|
          "<tr>#{ build_result_columns(indicator) }</tr>"
        }.join("")
      end

      def build_result_columns(indicator)
        columns = %w(name median strength weakness suggested_action)
        columns.map do |field|
          field_value = indicator[field]

          next build_column_median(field_value) if field == "median"

          value = field_value.kind_of?(Array) ? build_list(field_value) : field_value.to_s
          "<td>#{value}</td>"
        end.join("")
      end

      def build_column_median(median)
        str = I18n.t("rating_scale.#{median}") + " (#{VotingIndicator.medians[median]})"
        "<td class='text-center'>#{str}</td>"
      end

      def build_list(list)
        "<ul>" + list.map { |value| "<li>#{value}</li>" }.join("") + "</ul>"
      end
  end
end
