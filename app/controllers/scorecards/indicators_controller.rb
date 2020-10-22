# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find(params[:scorecard_id])
      @indicator = RaisedIndicatorService.new(@scorecard.uuid).indicators
      @voting_indicators = @scorecard.voting_indicators
    end
  end
end
