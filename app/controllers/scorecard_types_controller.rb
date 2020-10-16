# frozen_string_literal: true

class ScorecardTypesController < ApplicationController
  def index
    @pagy, @scorecard_types = pagy(current_program.scorecard_types)
  end

  def new
    @scorecard_type = authorize ScorecardType.new
  end

  def create
    @scorecard_type = authorize current_program.scorecard_types.new(scorecard_type_params)

    if @scorecard_type.save
      redirect_to scorecard_types_url
    else
      render :new
    end
  end

  def edit
    @scorecard_type = authorize ScorecardType.find(params[:id])
  end

  def update
    @scorecard_type = authorize ScorecardType.find(params[:id])

    if @scorecard_type.update_attributes(scorecard_type_params)
      redirect_to scorecard_types_url
    else
      render :edit
    end
  end

  def destroy
    @scorecard_type = authorize ScorecardType.find(params[:id])
    @scorecard_type.destroy

    redirect_to scorecard_types_url
  end

  private
    def scorecard_type_params
      params.require(:scorecard_type).permit(:name)
    end
end
