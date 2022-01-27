# frozen_string_literal: true

module ScorecardJson
  class ProposedIndicatorJsonBuilder
    attr_accessor :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def build
      {
        total: group_indicators.length,
        indicators: build_indicators
      }
    end

    private
      def build_indicators
        indicators = Indicator.where(uuid: raised_indicators.pluck(:indicator_uuid).uniq)
        indicators.map do |indi|
          criteria = {}
          criteria["name"] = indi.name
          criteria["tag"] = indi.tag_name
          criteria["count"] = raised_indicators.select { |ri| ri.indicator_uuid == indi.uuid }.length
          criteria["participants"] = build_participant(indi)
          criteria
        end.sort_by { |a| a["count"] }.reverse
      end

      def build_participant(indicator)
        participant_uuids = raised_indicators.select { |rd| rd.indicator_uuid == indicator.uuid }.pluck(:participant_uuid)
        {
          total: participant_uuids.length,
          profiles: build_profiles(participant_uuids)
        }
      end

      # [
      #   { type: "female",  count: 10 },
      #   ...
      # ]
      def build_profiles(participant_uuids)
        profiles = [ { type: "female", count: raised_participants.select { |participant| participant_uuids.include?(participant.uuid) && participant.gender == "female" }.length } ]

        %w(disability minority poor_card youth).each do |type|
          profiles << { type: type, count: raised_participants.select { |participant| participant_uuids.include?(participant.uuid) && !!participant[type] }.length }
        end

        profiles
      end

      def raised_indicators
        @raised_indicators ||= scorecard.raised_indicators
      end

      def raised_participants
        @raised_participants ||= ::Participant.where(uuid: raised_indicators.map(&:participant_uuid).uniq)
      end
  end
end
