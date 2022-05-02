# frozen_string_literal: true

module ExcelBuilders
  class VotingDetailExcelBuilder
    attr_accessor :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header

      @scorecards.includes(ratings: :voting_indicator).each do |scorecard|
        build_row(scorecard)
      end
    end

    def build_header
      sheet.add_row [
        I18n.t("excel.scorecard_id"),
        I18n.t("excel.participant_id"),
        I18n.t("excel.indicator_id"),
        I18n.t("excel.score"),
      ]
    end

    def build_row(scorecard)
      ratings = scorecard.ratings.uniq { |rating| [rating.participant_uuid, rating.voting_indicator_uuid] }
      ratings.sort_by { |rating| rating.participant_uuid }.each do |rating|
        sheet.add_row generate_row(rating, scorecard)
      end
    end

    private
      def generate_row(rating, scorecard)
        [
          scorecard.uuid,
          rating.participant_uuid,
          rating.voting_indicator.indicator_uuid,
          rating.score
        ]
      end
  end
end
