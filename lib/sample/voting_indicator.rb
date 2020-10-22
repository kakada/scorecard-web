# frozen_string_literal: true

module Sample
  class VotingIndicator
    def self.load
      scorecard = ::Scorecard.first
      return if scorecard.nil?

      indicators = RaisedIndicatorService.new(scorecard.uuid).indicators
      predefineds = indicators[:predefineds]
      customs = indicators[:customs]

      predefineds.take(4).each do |indi|
        scorecard.voting_indicators.create(indicatorable_id: indi["id"], indicatorable_type: "Indicator")
      end

      customs.take(1).each do |indi|
        scorecard.voting_indicators.create(indicatorable_id: indi["id"], indicatorable_type: "CustomIndicator")
      end
    end
  end
end
