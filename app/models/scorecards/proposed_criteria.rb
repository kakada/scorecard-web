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
      indicators = scorecard.raised_indicators.includes(:indicatorable)
      indicators = group_indicators.map do |key, value|
        indicators.select{ |indi| indi.indicatorable_id == key[0] && indi.indicatorable_type == key[1] }[0]
      end

      indicators.map do |indi|
        criteria = {}
        criteria["count"] = group_indicators[[indi.indicatorable_id, indi.indicatorable_type]]
        criteria["name"]  = indi.indicatorable.name
        criteria
      end.sort_by { |a| a["count"] }.reverse
    end

    private
      def group_tags
        @group_tags ||= scorecard.raised_indicators.group(:tag_id).count
      end

      def group_indicators
        @group_indicators ||= scorecard.raised_indicators.group(:indicatorable_id, :indicatorable_type).count
      end
  end
end
