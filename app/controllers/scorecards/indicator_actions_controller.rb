# frozen_string_literal: true

module Scorecards
  class IndicatorActionsController < ApplicationController
    def update
      @indicator_action = IndicatorAction.find params[:id]
      @indicator_action.update(indicator_action_param)

      respond_with_bip(@indicator_action.becomes(IndicatorAction))
    end

    private
      def indicator_action_param
        params.require(:indicator_action).permit(:name)
      end
  end
end
