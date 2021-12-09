# frozen_string_literal: true

module ScorecardExcel
  class ParticipantExcelBuilder
    attr_accessor :sheet

    def initialize(sheet)
      @sheet = sheet
    end

    def build_header
      sheet.add_row [
        I18n.t("scorecard.id"),
        I18n.t("scorecard.scorecard_id"),
        I18n.t("scorecard.gender"),
        I18n.t("scorecard.age"),
        I18n.t("scorecard.youth"),
        I18n.t("scorecard.disability"),
        I18n.t("scorecard.id_poor"),
        I18n.t("scorecard.minority")
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
          participant.scorecard.uuid,
          participant.gender,
          participant.age,
          participant.youth?,
          participant.disability?,
          participant.poor_card?,
          participant.minority?
        ]
      end
  end
end
