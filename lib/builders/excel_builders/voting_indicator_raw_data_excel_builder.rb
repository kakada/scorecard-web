# frozen_string_literal: true

module ExcelBuilders
  class VotingIndicatorRawDataExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.each do |scorecard|
        build_rows(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.scorecard_batch_code"),
        I18n.t("excel.indicator_id"),
        I18n.t("excel.indicator_name"),
        I18n.t("excel.median"),
        I18n.t("excel.strength"),
        I18n.t("excel.weakness"),
        I18n.t("excel.suggested_action"),
        I18n.t("excel.total_ratings"),
        I18n.t("excel.very_bad_count"),
        I18n.t("excel.bad_count"),
        I18n.t("excel.acceptable_count"),
        I18n.t("excel.good_count"),
        I18n.t("excel.very_good_count")
      ]
    end

    def build_rows(scorecard)
      scorecard.voting_indicators.includes(:indicator, :ratings).each do |vi|
        sheet.add_row generate_row(vi, scorecard)
      end
    end

    private
      def generate_row(voting_indicator, scorecard)
        rating_counts = calculate_rating_counts(voting_indicator)
        
        [
          scorecard.uuid,
          scorecard.scorecard_batch_code || "",
          voting_indicator.indicator_uuid || "",
          voting_indicator.indicator&.name || "",
          voting_indicator.median ? I18n.t("voting_indicator.median.#{VotingIndicator.medians.key(voting_indicator.median)}") : "",
          format_array_field(voting_indicator.strength),
          format_array_field(voting_indicator.weakness),
          format_array_field(voting_indicator.suggested_action),
          voting_indicator.ratings.size,
          rating_counts[1] || 0,  # very_bad
          rating_counts[2] || 0,  # bad
          rating_counts[3] || 0,  # acceptable
          rating_counts[4] || 0,  # good
          rating_counts[5] || 0   # very_good
        ]
      end

      def calculate_rating_counts(voting_indicator)
        voting_indicator.ratings.group(:score).count
      end

      def format_array_field(field)
        return "" if field.blank?
        field.is_a?(Array) ? field.join("; ") : field.to_s
      end
  end
end
