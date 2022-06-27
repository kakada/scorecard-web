# frozen_string_literal: true

module Scorecards
  class SwotsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_uuid])
      @voting_indicators = @scorecard.voting_indicators.includes(:indicator, proposed_indicator_actions: :indicator_action).order(:display_order)

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
