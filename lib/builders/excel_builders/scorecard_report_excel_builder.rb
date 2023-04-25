# frozen_string_literal: true

module ExcelBuilders
  class ScorecardReportExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
      @row_count = 0
    end

    def build
      build_header

      @scorecards.includes(:facility, :participants, voting_indicators: [:indicatorable, :ratings, :weakness_indicator_activities, :strength_indicator_activities, :suggested_indicator_activities, :participants]).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      header = sheet.workbook.styles.add_style bg_color: "FFDFDEDF", sz: 10, b: true, alignment: { horizontal: :center }

      sheet.add_row headers, style: header
    end

    def build_row(scorecard)
      @row_count += 1
      sheet.add_row main_row(scorecard, scorecard.voting_indicators.first, true), types: [:integer, :string]

      scorecard.voting_indicators.drop(1).each do |vi|
        @row_count += 1
        sheet.add_row main_row(scorecard, vi), types: [:integer, :string]
      end
    end

    private
      def headers
        @headers ||= [
          I18n.t("excel.number"),
          I18n.t("excel.scorecard_id"),
          I18n.t("excel.status"),
          I18n.t("excel.province"),
          I18n.t("excel.district"),
          I18n.t("excel.commune"),
          I18n.t("excel.lngo"),
          I18n.t("excel.number_of_caf"),
          I18n.t("excel.total_participant"),
          I18n.t("excel.number_of_participant_as_male"),
          I18n.t("excel.number_of_participant_as_female"),
          I18n.t("excel.number_of_youth"),
          I18n.t("excel.number_of_id_poor"),
          I18n.t("excel.number_of_minority"),
          I18n.t("excel.number_of_disability"),
          I18n.t("excel.scorecard_type"),
          I18n.t("excel.facility_name"),
          I18n.t("excel.conducted_place"),
          I18n.t("excel.indicator_development"),
          I18n.t("excel.custom_indicator"),
          # Raiser
          I18n.t("excel.raised_by_female"),
          I18n.t("excel.raised_by_youth"),
          I18n.t("excel.raised_by_id_poor"),
          I18n.t("excel.raised_by_ethnic_minority"),
          I18n.t("excel.raised_by_id_people_with_disability"),
          # Rating
          I18n.t("excel.very_bad"),
          I18n.t("excel.bad"),
          I18n.t("excel.acceptable"),
          I18n.t("excel.good"),
          I18n.t("excel.very_good"),
          I18n.t("excel.average_score"),
          # Activity
          I18n.t("excel.strength"),
          I18n.t("excel.weakness"),
          I18n.t("excel.suggested_action", number: 1),
          I18n.t("excel.suggested_action", number: 2),
          I18n.t("excel.suggested_action", number: 3),
          # conducted date
          I18n.t("excel.meeting_date")
        ]
      end

      def main_row(scorecard, voting_indicator, is_first_row = false)
        [
          @row_count,
          scorecard.uuid,
          I18n.t("scorecard.#{scorecard.status}"),
          scorecard.province,
          scorecard.district,
          scorecard.commune,
          scorecard.local_ngo_name,
          (scorecard.number_of_caf if is_first_row),
          (scorecard.number_of_participant if is_first_row),
          (scorecard.participants.select(&:male?).length if is_first_row && scorecard.participants.present?),
          (scorecard.number_of_female if is_first_row),
          (scorecard.number_of_youth if is_first_row),
          (scorecard.number_of_id_poor if is_first_row),
          (scorecard.number_of_ethnic_minority if is_first_row),
          (scorecard.number_of_disability if is_first_row),
          I18n.t("excel.#{scorecard.scorecard_type}"),
          scorecard.facility_name,
          scorecard.conducted_place
        ]
        .concat(scorecard_result(voting_indicator))
        .concat([format_date(scorecard.conducted_date)])
      end

      def scorecard_result(voting_indicator)
        return [] unless voting_indicator.present?

        [
          (voting_indicator.indicatorable.custom? ? I18n.t("excel.other") : voting_indicator.indicatorable.name),
          (voting_indicator.indicatorable.name if voting_indicator.indicatorable.custom?),
          voting_indicator.participants.select(&:female?).length,
          voting_indicator.participants.select(&:youth?).length,
          voting_indicator.participants.select(&:poor_card?).length,
          voting_indicator.participants.select(&:minority?).length,
          voting_indicator.participants.select(&:disability?).length
        ]
        .concat(rating(voting_indicator))
        .concat(result(voting_indicator))
      end

      def rating(voting_indicator)
        VotingIndicator.medians.map do |median|
          count = voting_indicator.ratings.select { |rating| rating.score == median[1] }.length
          count.zero? ? nil : count
        end
      end

      def result(voting_indicator)
        data = [
          I18n.t("excel.#{voting_indicator.median}"),
          voting_indicator.strength_indicator_activities.map { |act| act.content }.join("; "),
          voting_indicator.weakness_indicator_activities.map { |act| act.content }.join("; ")
        ]

        3.times.each do |i|
          data.push(voting_indicator.suggested_indicator_activities[i].try(:content))
        end

        data
      end

      def format_date(date)
        return nil unless date.present?

        I18n.l(date, format: :nice)
      end
  end
end
