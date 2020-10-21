# frozen_string_literal: true

class ScorecardsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @pagy, @scorecards = pagy(Scorecard.order(sort_column + " " + sort_direction).includes(:category))
  end

  def show
    @scorecard = Scorecard.find(params[:id])
  end

  def new
    @scorecard = authorize Scorecard.new
  end

  def create
    @scorecard = authorize current_program.scorecards.new(scorecard_params)

    if @scorecard.save
      redirect_to scorecards_url
    else
      render :new
    end
  end

  def edit
    @scorecard = authorize Scorecard.find(params[:id])
  end

  def update
    @scorecard = authorize Scorecard.find(params[:id])

    if @scorecard.update_attributes(scorecard_params)
      redirect_to scorecards_url
    else
      render :edit
    end
  end

  def destroy
    @scorecard = authorize Scorecard.find(params[:id])
    @scorecard.destroy

    redirect_to scorecards_url
  end

  private
    def sort_column
      Scorecard.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def scorecard_params
      params.require(:scorecard).permit(:unit_type_id, :category_id, :description,
        :province_id, :district_id, :commune_id, :year, :conducted_date,
        :number_of_caf, :number_of_participant, :number_of_female,
        :planned_start_date, :planned_end_date, :local_ngo_id, :scorecard_type_id
      )
    end
end
