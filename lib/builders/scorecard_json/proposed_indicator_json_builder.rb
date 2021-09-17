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
        indicatorables = group_indicators.map do |key, value|
          raised_indicators.select { |indi| indi.indicatorable_id == key[0] && indi.indicatorable_type == key[1] }[0].indicatorable
        end

        indicatorables.map do |indi|
          criteria = {}
          criteria["name"] = indi.name
          criteria["tag"] = indi.tag_name
          criteria["count"] = group_indicators[[indi.id, indi.class.name]]
          criteria["participants"] = build_participant(indi)
          criteria
        end.sort_by { |a| a["count"] }.reverse
      end

      def build_participant(indicatorable)
        participant_uuids = raised_indicators.select { |rd| rd.indicatorable_id == indicatorable.id && rd.indicatorable_type == indicatorable.class.name }.pluck(:participant_uuid)
        {
          total: participant_uuids.length,
          profiles: build_profiles(participant_uuids, indicatorable)
        }
      end

      # [
      #   { type: "female",  count: 10 },
      #   ...
      # ]
      def build_profiles(participant_uuids, indicator)
        profiles = [ { type: "female", count: raised_participants.select { |participant| participant_uuids.include?(participant.uuid) && participant.gender == "female" }.length } ]

        %w(disability minority poor_card youth).each do |type|
          profiles << { type: type, count: raised_participants.select { |participant| participant_uuids.include?(participant.uuid) && !!participant[type] }.length }
        end

        profiles
      end

      def group_indicators
        @group_indicators ||= scorecard.raised_indicators.group(:indicatorable_id, :indicatorable_type).count
      end

      def raised_indicators
        @raised_indicators ||= scorecard.raised_indicators.includes(:indicatorable)
      end

      def raised_participants
        @raised_participants ||= ::Participant.where(uuid: raised_indicators.map(&:participant_uuid).uniq)
      end
  end
end
