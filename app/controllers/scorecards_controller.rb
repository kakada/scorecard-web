# frozen_string_literal: true

class ScorecardsController < ApplicationController
  def index
    @pagy, @scorecards = pagy(Scorecard.all)
  end
end
