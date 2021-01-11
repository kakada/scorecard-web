# frozen_string_literal: true

module Scorecards
  class ProposedCriteria
    attr_reader :scorecard

    def initialize(scorecard_uuid)
      @scorecard = Scorecard.find_by(uuid: scorecard_uuid)
    end

    def tags
      @tags = Tag.where(id: group_tags.keys).as_json

      @tags.each do |item|
        item["count"] = group_tags[item["id"]]
      end

      @tags.sort_by { |a| a["count"] }.reverse
    end

    def criterias
      _criterias = group_indicators.map do |key, value|
        raised_indicators.select { |indi| indi.indicatorable_id == key[0] && indi.indicatorable_type == key[1] }[0].indicatorable
      end

      _criterias.map do |indi|
        criteria = indi.as_json
        criteria = assign_participant_info(criteria, indi)
        criteria["count"] = group_indicators[[indi.id, indi.class.name]]
        criteria
      end.sort_by { |a| a["count"] }.reverse
    end

    private
      def assign_participant_info(criteria = {}, indicator)
        uuids = raised_indicators.select { |rd| rd.indicatorable_id == indicator.id && rd.indicatorable_type == indicator.class.name }.pluck(:participant_uuid)

        %w(minority disability poor_card youth).each do |field|
          criteria["#{field}_count"] = raised_participants.select { |participant| uuids.include?(participant.uuid) && !!participant[field] }.length
        end

        criteria["female_count"] = raised_participants.select { |participant| uuids.include?(participant.uuid) && participant.gender == "female" }.length
        criteria
      end

      def group_tags
        @group_tags ||= scorecard.raised_indicators.group(:tag_id).count
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
