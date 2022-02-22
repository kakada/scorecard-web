# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_uuid])
      @criterias = Scorecards::ProposedCriteria.new(@scorecard).criterias

      respond_to do |format|
        format.html
        format.js
      end
    end

    def update
      @indicator = Indicator.find(params[:id])
      @indicator.update(custom_indicator_params)

      respond_with_bip(@indicator)
    end

    private
      def custom_indicator_params
        params.require(:indicator).permit(:name)
      end
  end
end
