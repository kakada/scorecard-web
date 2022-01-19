# frozen_string_literal: true

module ScorecardExcel
  class ScorecardSummaryExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
    end

    def build_header
      sheet.add_row [
        I18n.t("scorecard.id"),
        I18n.t("scorecard.type"),
        I18n.t("scorecard.number_of_participant"),
        I18n.t("scorecard.number_of_female"),
        I18n.t("scorecard.number_of_male"),
        I18n.t("scorecard.number_of_other"),
        I18n.t("scorecard.number_of_youth"),
        I18n.t("scorecard.number_of_ethnic_minority"),
        I18n.t("scorecard.number_of_disability"),
        I18n.t("scorecard.number_of_id_poor"),
        I18n.t("scorecard.number_of_proposed_indicator"),
        I18n.t("scorecard.number_of_indicator_development"),
        I18n.t("scorecard.number_of_proposed_suggested_actions"),
        I18n.t("scorecard.number_of_suggested_actions")
      ]
    end

    def build_row(scorecard)
      sheet.add_row generate_row(scorecard)
    end

    private
      def generate_row(scorecard)
        [
          scorecard.uuid,
          scorecard.scorecard_type,
          scorecard.number_of_participant,
          scorecard.number_of_female,
          scorecard.participants.males.length,
          scorecard.participants.others.length,
          scorecard.number_of_youth,
          scorecard.number_of_ethnic_minority,
          scorecard.number_of_disability,
          scorecard.number_of_id_poor,
          scorecard.raised_indicators.length,
          scorecard.voting_indicators.length,
          scorecard.suggested_actions.length,
          scorecard.suggested_actions.selecteds.length
        ]
      end
  end
end
