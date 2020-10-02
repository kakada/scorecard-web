# frozen_string_literal: true

class ScorecardsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @pagy, @scorecards = pagy(Scorecard.order(sort_column + " " + sort_direction))
  end

  def show
    @scorecard = Scorecard.find(params[:id])
  end

  private
    def sort_column
      Scorecard.column_names.include?(params[:sort]) ? params[:sort] : "conducted_year"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
