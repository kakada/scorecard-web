# frozen_string_literal: true

module ExcelBuilders
  class ParticipantExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
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
      scorecard.participants.find_each do |p|
        sheet.add_row generate_row(p, scorecard)
      end
    end

    private
      def generate_row(participant, scorecard)
        [
          participant.uuid,
          participant.scorecard_uuid,
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
