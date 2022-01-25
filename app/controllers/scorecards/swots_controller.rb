# frozen_string_literal: true

module Scorecards
  class SwotsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_uuid])
      @voting_indicators = @scorecard.voting_indicators.includes(:indicator, :suggested_actions).order(:display_order)

      respond_to do |format|
        format.js
      end
    end
  end
end
