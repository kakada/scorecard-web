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
          name: "custom_indicator_#{i}",
          audio: ""
        )
        assign_audio(custom_indicator)

        scorecard.raised_indicators.create(indicatorable: custom_indicator)
      end
    end

    private
      def self.assign_audio(indicator)
        audio = indicators.select { |file| file.split("/").last.split(".").first == indicator[:name] }.first
        return if audio.nil? || !File.exist?(audio)

        indicator.audio = Pathname.new(audio).open
        indicator.save
      end

      def self.indicators
        @indicators ||= Dir.glob(Rails.root.join("lib", "sample", "assets", "indicators", "*"))
      end
  end
end
