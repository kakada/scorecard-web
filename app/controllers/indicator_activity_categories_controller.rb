# frozen_string_literal: true

class IndicatorActivityCategoriesController < ApplicationController
  before_action :set_indicator_activity_category, only: [:edit, :update, :destroy, :move]

  def index
    authorize IndicatorActivityCategory
    @pagy, @indicator_activity_categories = pagy(policy_scope(current_program.indicator_activity_categories).ordered)
  end

  def new
    @indicator_activity_category = authorize current_program.indicator_activity_categories.new
  end

  def create
    @indicator_activity_category = authorize current_program.indicator_activity_categories.new(indicator_activity_category_params)

    if @indicator_activity_category.save
      redirect_to indicator_activity_categories_url
    else
      render :new
    end
  end

  def edit
    authorize @indicator_activity_category
  end

  def update
    authorize @indicator_activity_category

    if @indicator_activity_category.update(indicator_activity_category_params)
      redirect_to indicator_activity_categories_url
    else
      render :edit
    end
  end

  def destroy
    authorize @indicator_activity_category
    if @indicator_activity_category.remove!
      flash[:notice] = t("indicator_activity_category.deleted")
    else
      flash[:alert] = t("indicator_activity_category.already_in_use")
    end

    redirect_to indicator_activity_categories_url
  end

  def move
    authorize @indicator_activity_category, :update?

    if params[:direction] == "up"
      @indicator_activity_category.move_up!
    elsif params[:direction] == "down"
      @indicator_activity_category.move_down!
    else
      flash[:alert] = t("indicator_activity_category.invalid_direction")
    end

    redirect_to indicator_activity_categories_url
  end

  private
    def set_indicator_activity_category
      raise ActiveRecord::RecordNotFound unless current_program.present?

      @indicator_activity_category = current_program.indicator_activity_categories.find(params[:id])
    end

    def indicator_activity_category_params
      params.require(:indicator_activity_category).permit(:name_en, :name_km, :description_en, :description_km)
    end
end
