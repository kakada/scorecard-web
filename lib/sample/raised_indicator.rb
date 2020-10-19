# frozen_string_literal: true

module Sample
  class RaisedIndicator
    def self.load
      scorecard = ::Scorecard.first
      return if scorecard.nil?

      scorecard.number_of_participant.to_i.times do |i|
        scorecard.raised_indicators.create(
          indicatorable: scorecard.category.indicators.sample
        )
      end

      scorecard.number_of_female.to_i.times do |i|
        custom_indicator = scorecard.custom_indicators.create(
          name: "custom indicator #{i}",
          audio: ''
        )

        scorecard.raised_indicators.create(indicatorable: custom_indicator)
      end
    end
  end
end
