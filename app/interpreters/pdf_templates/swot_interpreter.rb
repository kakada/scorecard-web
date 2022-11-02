# frozen_string_literal: true

module PdfTemplates
  class SwotInterpreter
    def initialize(scorecard)
      @scorecard = scorecard
      @proposed_indicators = Scorecards::ProposedCriteria.new(@scorecard).criterias
    end

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
        headers = columns.map { |col| "<th class='text-center'>" + I18n.t("scorecard.#{col}") + "</th>" }.join("")

        "<tr>#{headers}</tr>"
      end

      def render_body
        @scorecard.voting_indicators.map { |vi| "<tr>#{ render_each_row(vi) }</tr>" }.join("")
      end

      def render_each_row(voting_indicator)
        build_column_indicator_name(voting_indicator) +
        build_column_median(voting_indicator.median) +
        build_column_activity(voting_indicator.strength_indicator_activities) +
        build_column_activity(voting_indicator.weakness_indicator_activities) +
        build_column_activity(voting_indicator.suggested_indicator_activities)
      end

      def build_column_indicator_name(voting_indicator)
        "<td>" +
          voting_indicator.indicator.name + "<br/>" +
          render_participant_profiles(voting_indicator) +
        "</td>"
      end

      def render_participant_profiles(voting_indicator)
        criteria = @proposed_indicators.select { |pi| pi["indicator"].uuid == voting_indicator.indicator_uuid }.first

        str = participant_profiles.map { |field| participant_info(criteria, field) }.compact.join(", ")
        str = "<span class='participant-profile'>#{str}</span>" if str.present?
        str
      end

      def participant_info(criteria, field)
        return unless criteria.present?

        value = criteria["#{field}_count"].to_i
        I18n.t("scorecard.#{field}_shortcut") + ": #{value}" if value.positive?
      end

      def render_shortcut_note
        "<div>" +
          "#{I18n.t('scorecard.note')}: " +
          participant_profiles.map { |profile| I18n.t("scorecard.#{profile}_shortcut") + ": " + I18n.t("scorecard.#{profile}_fullword") }.join(", ") +
        "</div>"
      end

      def build_column_median(median)
        str = I18n.t("rating_scale.#{median}") + " (#{VotingIndicator.medians[median]})"
        "<td class='text-center'>#{str}</td>"
      end

      def build_column_activity(indicator_activities)
        str = "<td><ul>"
        str += indicator_activities.map { |indicator_activity|
          selected = indicator_activity.selected? ? "(#{I18n.t('indicator.selected')})" : ""
          "<li>#{indicator_activity.content} #{selected}</li>"
        }.join("")

        str + "</ul></td>"
      end

      def participant_profiles
        @participant_profiles ||= %w(female minority disability poor_card youth)
      end
  end
end
