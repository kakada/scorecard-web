# frozen_string_literal: true

module Scorecards
  class ProposedCriteria
    attr_reader :scorecard

    def initialize(scorecard_uuid)
      @scorecard = Scorecard.find_by(uuid: scorecard_uuid)
    end

    def tags
      tags = Tag.where(id: group_tags.keys).as_json

      tags.each do |item|
        item["count"] = group_tags[item["id"]]
      end

      tags.sort_by { |a| a["count"] }.reverse
    end

    private
      def group_tags
        @group_tags ||= scorecard.raised_indicators.group(:tag_id).count
      end
  end
end
