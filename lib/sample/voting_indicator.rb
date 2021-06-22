# frozen_string_literal: true

module Sample
  class VotingIndicator
    def self.load(scorecard)
      indicators = RaisedIndicatorService.new(scorecard.uuid).indicators
      predefineds = indicators[:predefineds]
      customs = indicators[:customs]

      predefineds.take(4).each_with_index do |indi, index|
        scorecard.voting_indicators.create(
          indicatorable_id: indi["id"],
          indicatorable_type: "Indicator",
          suggested_actions_attributes: [
            { scorecard_uuid: scorecard.uuid, content: "action1_#{index}", selected: true },
            { scorecard_uuid: scorecard.uuid, content: "action2_#{index}", selected: false },
          ]
        )
      end

      customs.take(1).each do |indi|
        scorecard.voting_indicators.create(indicatorable_id: indi["id"], indicatorable_type: "CustomIndicator")
      end
    end
  end
end
