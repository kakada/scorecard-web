# frozen_string_literal: true

module ExcelBuilders
  class ParticipantExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(:participants).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.participant_id"),
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.age"),
        I18n.t("excel.gender"),
        I18n.t("excel.youth"),
        I18n.t("excel.disability"),
        I18n.t("excel.id_poor"),
        I18n.t("excel.minority")
      ]
    end

    def build_row(scorecard)
      scorecard.participants.find_each do |participant|
        sheet.add_row generate_row(participant)
      end
    end

    private
      def generate_row(participant)
        [
          participant.uuid,
          participant.scorecard.uuid,
          participant.age,
          participant.gender,
          participant.youth?,
          participant.disability?,
          participant.poor_card?,
          participant.minority?
        ]
      end
  end
end
