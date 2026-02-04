# frozen_string_literal: true

# Todo: change name to Aggregate Proposed Indicator
module Scorecards
  class ProposedCriteria
    attr_reader :scorecard

    def initialize(scorecard)
      @scorecard = scorecard
    end

    def criterias
      _criterias = Indicator.where(uuid: raised_indicators.pluck(:indicator_uuid).uniq)
      _criterias.map do |indi|
        criteria = indi.as_json
        criteria["indicator"] = indi
        criteria = assign_participant_info(criteria, indi)
        criteria["count"] = raised_indicators.select { |ri| ri.indicator_uuid == indi.uuid }.length
        criteria
      end.sort_by { |a| a["count"] }.reverse
    end

    private
      def assign_participant_info(criteria = {}, indicator)
        uuids = raised_indicators.select { |rd| rd.indicator_uuid == indicator.uuid }.pluck(:participant_uuid)

        %w(minority disability poor_card youth).each do |field|
          criteria["#{field}_count"] = raised_participants.select { |participant| uuids.include?(participant.uuid) && !!participant[field] }.length
        end

        criteria["female_count"] = raised_participants.select { |participant| uuids.include?(participant.uuid) && participant.gender == "female" }.length
        criteria
      end

      def raised_indicators
        @raised_indicators ||= scorecard.raised_indicators
      end

      def raised_participants
        @raised_participants ||= scorecard.raised_participants
      end
  end
end
