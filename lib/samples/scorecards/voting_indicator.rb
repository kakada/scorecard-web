# frozen_string_literal: true

module Samples
  module Scorecards
    class VotingIndicator
      def self.load(scorecard)
        predefineds = scorecard.facility.indicators.predefines
        customs = scorecard.facility.indicators.customs
        predefineds.take(4).each_with_index do |indi, index|
          scorecard.voting_indicators.create(
            indicatorable_id: indi["id"],
            indicatorable_type: "Indicators::PredefineIndicator",
            indicator_uuid: indi["uuid"],
            proposed_indicator_actions_attributes: [
              build_indicator_action({scorecard: scorecard, indicator: indi, kind: "weakness", predefined: false}),
              build_indicator_action({scorecard: scorecard, indicator: indi, kind: "strength", predefined: false}),
              build_indicator_action({scorecard: scorecard, indicator: indi, kind: "suggested_action", predefined: false}),
              build_indicator_action({scorecard: scorecard, indicator: indi, kind: "suggested_action", predefined: true})
            ]
          )
        end

        customs.take(1).each do |indi|
          scorecard.voting_indicators.create(indicator_uuid: indi["uuid"], indicatorable_id: indi["id"], indicatorable_type: "Indicators::CustomIndicator")
        end
      end

      class << self
        private
          def build_indicator_action(option={})
            name = option[:predefined] ? "Predefined" : "Custom"
            name = "#{name} #{option[:kind]} - #{rand(9)}"

            {
              selected: !!option[:predefined],
              scorecard_uuid: option[:scorecard].uuid,
              kind: option[:kind],
              indicator_action_attributes: {
                name: name,
                predefined: option[:predefined],
                kind: option[:kind],
                indicator_uuid: option[:indicator].uuid
              }
            }
          end
        end
    end
  end
end
