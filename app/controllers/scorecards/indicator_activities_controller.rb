# frozen_string_literal: true

module Scorecards
  class IndicatorActivitiesController < ApplicationController
    def update
      @indicator_activity = IndicatorActivity.find params[:id]
      @indicator_activity.update(indicator_activity_param)

      respond_with_bip(@indicator_activity.becomes(IndicatorActivity))
    end

    private
      def indicator_activity_param
        params.require(:indicator_activity).permit(:content)
      end
  end
end
