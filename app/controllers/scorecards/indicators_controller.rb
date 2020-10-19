# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find(params[:scorecard_id])

      predefineds = @scorecard.raised_indicators.where(indicatorable_type: 'Indicator').group(:indicatorable_id).count
      customs = @scorecard.raised_indicators.where(indicatorable_type: 'CustomIndicator').group(:indicatorable_id).count

      @indicators = Indicator.where(id: predefineds.keys).as_json
      @indicators.each do |item|
        item['count'] = predefineds[item['id']]
      end

      @custom_indicators = CustomIndicator.where(id: customs.keys)
    end
  end
end
