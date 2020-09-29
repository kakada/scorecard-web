# frozen_string_literal: true

class ScorecardsController < ApplicationController
  def index
    @pagy, @scorecards = pagy(Scorecard.all)
  end

  def show
    @scorecard = Scorecard.find(params[:id])
  end
end
