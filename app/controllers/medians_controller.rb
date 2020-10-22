# frozen_string_literal: true

class MediansController < ApplicationController
  def index
    @scorecard = Scorecard.find(params[:scorecard_id])

    @voting_indicators = @scorecard.voting_indicators
  end
end
