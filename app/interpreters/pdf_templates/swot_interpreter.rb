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
        @scorecard.voting_indicators.map { |vi|
          "<tr>#{ build_result_columns(vi) }</tr>"
        }.join("")
      end

      def build_result_columns(voting_indicator)
        str = "<td>#{voting_indicator.indicator.name}</td>"
        str += build_column_median(voting_indicator.median)
        str += build_list(voting_indicator.strength_indicator_activities)
        str += build_list(voting_indicator.weakness_indicator_activities)
        str + build_list(voting_indicator.suggested_indicator_activities)
      end

      def build_column_median(median)
        str = I18n.t("rating_scale.#{median}") + " (#{VotingIndicator.medians[median]})"
        "<td class='text-center'>#{str}</td>"
      end

      def build_list(indicator_activities)
        str = "<td><ul>"
        str += indicator_activities.map { |indicator_activity|
          selected = indicator_activity.selected? ? "(#{I18n.t('indicator.selected')})" : ""
          "<li>#{indicator_activity.content} #{selected}</li>"
        }.join("")

        str + "</ul></td>"
      end
  end
end
