# frozen_string_literal: true

module Sample
  class RaisedIndicator
    def self.load(scorecard)
      create_proposed_criteria_with_predefined_indicator(scorecard)
      create_proposed_criteria_with_custom_indicator(scorecard)
    end

    private
      def self.create_proposed_criteria_with_predefined_indicator(scorecard)
        indicators = scorecard.facility.indicators

        scorecard.number_of_participant.to_i.times do |i|
          create_proposed_criteria(scorecard, indicators.sample, i)
        end
      end

      def self.create_proposed_criteria_with_custom_indicator(scorecard)
        scorecard.number_of_female.to_i.times do |i|
          custom_indicator = scorecard.custom_indicators.create(
            name: "custom_indicator_#{i}",
            audio: "",
            tag_attributes: { name: "other" }
          )
          assign_audio(custom_indicator)

          create_proposed_criteria(scorecard, custom_indicator, i)
        end
      end

      def self.create_proposed_criteria(scorecard, indicator, participant_index)
        participant = scorecard.participants[participant_index]
        scorecard.raised_indicators.create(
          indicatorable: indicator,
          tag_id: indicator.tag_id,
          participant_uuid: participant.uuid
        )
      end

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
