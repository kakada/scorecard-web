# frozen_string_literal: true

class RaisedIndicatorService
  attr_reader :scorecard

  def initialize(scorecard_uuid)
    @scorecard = Scorecard.find_by(uuid: scorecard_uuid)
  end

  def indicators
    {
      predefineds: predefineds,
      customs: customs
    }
  end

  private
    def predefineds
      pre_indicators = Indicator.where(id: group_predefineds.keys).as_json
      pre_indicators.each do |item|
        item["count"] = group_predefineds[item["id"]]
      end

      pre_indicators
    end

    def customs
      CustomIndicator.where(id: group_customs.keys)
    end

    def group_predefineds
      @group_predefineds ||= scorecard.raised_indicators.where(indicatorable_type: "Indicator").group(:indicatorable_id).count
    end

    def group_customs
      @group_customs ||= scorecard.raised_indicators.where(indicatorable_type: "CustomIndicator").group(:indicatorable_id).count
    end
end
