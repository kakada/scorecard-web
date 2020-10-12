# frozen_string_literal: true

class IndicatorsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @pagy, @indicators = pagy(Indicator.order(sort_column + " " + sort_direction).includes(:category))
  end

  def show
    @indicator = Indicator.find(params[:id])
  end

  def new
    @indicator = authorize Indicator.new
  end

  def create
    @indicator = authorize current_program.indicators.new(indicator_params)

    if @indicator.save
      redirect_to indicators_url
    else
      render :new
    end
  end

  def edit
    @indicator = authorize Indicator.find(params[:id])
  end

  def update
    @indicator = authorize Indicator.find(params[:id])

    if @indicator.update_attributes(indicator_params)
      redirect_to indicators_url
    else
      render :edit
    end
  end

  def destroy
    @indicator = authorize Indicator.find(params[:id])
    @indicator.destroy

    redirect_to indicators_url
  end

  private
    def sort_column
      Indicator.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def indicator_params
      params.require(:indicator).permit(:name, :sector_id, :category_id, :name, :tag)
    end
end
