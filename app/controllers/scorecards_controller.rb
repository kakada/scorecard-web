# frozen_string_literal: true

class ScorecardsController < ApplicationController
  def index
    @pagy, @scorecards = pagy(policy_scope(Scorecard.filter(params).order(sort_column + " " + sort_direction).includes(:facility)))
  end

  def show
    @scorecard = Scorecard.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @scorecard = authorize Scorecard.new
  end

  def create
    @scorecard = authorize current_program.scorecards.new(scorecard_params)

    if @scorecard.save
      flash[:notice] = t("scorecard.create_successfully")
      redirect_to scorecard_url(@scorecard)
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
    def scorecard_params
      params.require(:scorecard).permit(:unit_type_id, :facility_id, :description,
        :province_id, :district_id, :commune_id, :year,
        :planned_start_date, :planned_end_date, :local_ngo_id, :scorecard_type
      ).merge({ creator_id: current_user.id })
    end
end
