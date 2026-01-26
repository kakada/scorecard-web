# frozen_string_literal: true

module Samples
  module Scorecards
    class RaisedIndicator
      def self.load(scorecard)
        create_raised_indicator_as_predefined(scorecard)
        create_raised_indicator_as_custom(scorecard)
      end

      private
        def self.create_raised_indicator_as_predefined(scorecard)
          indicators = scorecard.facility.indicators.predefines

          scorecard.number_of_participant.to_i.times do |i|
            create_raised_indicator(scorecard, indicators.sample, i)
          end
        end

        def self.create_raised_indicator_as_custom(scorecard)
          scorecard.number_of_female.to_i.times do |i|
            custom_indicator = scorecard.facility.indicators.create(
              name: "custom_indicator_#{i}",
              audio: "",
              tag_attributes: { name: "other" },
              type: "Indicators::CustomIndicator"
            )

            create_raised_indicator(scorecard, custom_indicator, i)
          end
        end

        def self.create_raised_indicator(scorecard, indicator, participant_index)
          participant = scorecard.participants[participant_index]
          scorecard.raised_indicators.create(
            indicator_uuid: indicator.uuid,
            tag_id: indicator.tag_id,
            participant_uuid: participant.uuid
          )
        end
    end
  end
end
