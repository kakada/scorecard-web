# frozen_string_literal: true

module Scorecards
  class SwotsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_uuid])
      @voting_indicators = @scorecard.voting_indicators.includes(:indicator, :weakness_indicator_activities, :strength_indicator_activities, suggested_indicator_activities: :indicator_activity_category).order(:display_order)

      @indicator_activity_categories = IndicatorActivityCategory.order(display_order: :asc)
      @indicator_activity_categories_for_select = @indicator_activity_categories.map do |category|
        [category.id, category.name]
      end

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
