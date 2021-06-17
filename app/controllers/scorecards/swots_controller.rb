# frozen_string_literal: true

module Scorecards
  class SwotsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_id])
      @voting_indicators = @scorecard.voting_indicators.includes(:indicatorable, :suggested_actions).order(median: :DESC)

      respond_to do |format|
        format.js
      end
    end
  end
end
