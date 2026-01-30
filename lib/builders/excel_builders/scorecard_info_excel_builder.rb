# frozen_string_literal: true

module ExcelBuilders
  class ScorecardInfoExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:local_ngo).each do |scorecard|
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
        I18n.t("excel.running_mode"),
        I18n.t("excel.implementer"),
        I18n.t("excel.total_ratings")
      ]
    end

    def build_row(scorecard)
      row = generate_row(scorecard)
      sheet.add_row row, types: Array.new(row.size, :string)
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
          I18n.t("scorecard.running_mode_#{scorecard.running_mode}"),
          scorecard.local_ngo_name,
          scorecard.number_of_participant
        ]
      end

      def format_date(date)
        return "" unless date.present?

        I18n.l(date, format: :nice)
      end
  end
end
