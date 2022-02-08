# frozen_string_literal: true

module ExcelBuilders
  class ScorecardSummaryExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:local_ngo, :participants, :raised_indicators, :voting_indicators, :suggested_indicator_activities).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.location"),
        I18n.t("excel.planned_start_date"),
        I18n.t("excel.planned_end_date"),
        I18n.t("excel.submitted_date"),
        I18n.t("excel.completed_date"),
        I18n.t("excel.status"),
        I18n.t("excel.scorecard_type"),
        I18n.t("excel.implementer"),
        I18n.t("excel.total_participant"),
        I18n.t("excel.number_of_participant_as_female"),
        I18n.t("excel.number_of_participant_as_male"),
        I18n.t("excel.number_of_participant_as_other"),
        I18n.t("excel.number_of_youth"),
        I18n.t("excel.number_of_minority"),
        I18n.t("excel.number_of_disability"),
        I18n.t("excel.number_of_id_poor"),
        I18n.t("excel.number_of_raised_indicator"),
        I18n.t("excel.number_of_selected_for_voting"),
        I18n.t("excel.total_suggested_action"),
        I18n.t("excel.total_selected_suggested_action")
      ]
    end

    def build_row(scorecard)
      sheet.add_row generate_row(scorecard)
    end

    private
      def generate_row(scorecard)
        [
          scorecard.uuid,
          scorecard.location_name,
          format_date(scorecard.planned_start_date),
          format_date(scorecard.planned_end_date),
          format_date(scorecard.submitted_at),
          format_date(scorecard.completed_at),
          I18n.t("scorecard.#{scorecard.status}"),
          I18n.t("scorecard.#{scorecard.scorecard_type}"),
          scorecard.local_ngo_name,
          scorecard.number_of_participant,
          scorecard.number_of_female,
          scorecard.participants.select { |p| p.gender == Participant::GENDER_MALE}.length,
          scorecard.participants.select { |p| p.gender == Participant::GENDER_OTHER}.length,
          scorecard.number_of_youth,
          scorecard.number_of_ethnic_minority,
          scorecard.number_of_disability,
          scorecard.number_of_id_poor,
          scorecard.raised_indicators.pluck(:indicator_uuid).uniq.length,
          scorecard.voting_indicators.length,
          scorecard.suggested_indicator_activities.length,
          scorecard.suggested_indicator_activities.select { |act| act.selected? }.length
        ]
      end

      def format_date(date)
        return "" unless date.present?

        I18n.l(date, format: :nice)
      end
  end
end
