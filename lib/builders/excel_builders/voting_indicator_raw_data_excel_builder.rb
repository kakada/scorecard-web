# frozen_string_literal: true

module ExcelBuilders
  class VotingIndicatorRawDataExcelBuilder
    SCORECARD_LIMIT = ENV.fetch(
      "MAX_DOWNLOAD_VOTING_INDICATOR_SCORECARD_LIMIT",
      50
    ).to_i

    HEADER_KEYS = %w[
      excel.scorecard_id
      excel.indicator_name
      excel.median
      excel.very_bad_count
      excel.bad_count
      excel.acceptable_count
      excel.good_count
      excel.very_good_count
    ].freeze

    attr_reader :sheet

    def initialize(sheet, scorecards)
      @sheet = sheet
      @scorecards = scorecards
    end

    def build
      build_header
      @scorecards.each { |scorecard| build_rows(scorecard) }
    end

    private
      def build_header
        sheet.add_row HEADER_KEYS.map { |key| I18n.t(key) }
      end

      def build_rows(scorecard)
        scorecard.voting_indicators.each do |voting_indicator|
          row = generate_row(voting_indicator, scorecard)
          sheet.add_row row, types: Array.new(row.size, :string)
        end
      end

      def generate_row(voting_indicator, scorecard)
        rating_counts = rating_counts_for(voting_indicator)
        [
          scorecard.uuid,
          voting_indicator.indicator&.name.to_s,
          voting_indicator.median_before_type_cast.to_s,
          rating_counts[1],
          rating_counts[2],
          rating_counts[3],
          rating_counts[4],
          rating_counts[5]
        ]
      end

      def rating_counts_for(voting_indicator)
        voting_indicator.ratings.each_with_object(Hash.new(0)) do |rating, counts|
          counts[rating.score] += 1
        end
      end
  end
end
