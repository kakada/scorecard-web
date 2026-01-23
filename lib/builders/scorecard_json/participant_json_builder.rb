# frozen_string_literal: true

module ScorecardJson
  class ParticipantJsonBuilder
    attr_accessor :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def build
      {
        total: scorecard.participants.length,
        profiles: build_profiles
      }
    end

    private
      # [
      #   { type: "female",  count: 10 },
      #   ...
      # ]
      def build_profiles
        profiles = [ { type: "female", count: scorecard.participants.select { |participant| participant.gender == "female" }.length } ]

        %w(disability minority poor_card youth none).each do |type|
          profiles << { type: type, count: scorecard.participants.select { |participant| !!participant.send(type) }.length }
        end

        profiles
      end
  end
end
