# frozen_string_literal: true

module Scorecards
  class MediansController < ApplicationController
    def index
      @scorecard = Scorecard.find(params[:scorecard_id])

      @voting_indicators = @scorecard.voting_indicators
    end
  end
end
