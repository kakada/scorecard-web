# frozen_string_literal: true

class DatasetsController < ApplicationController
  before_action :set_category

  def index
    @pagy, @datasets = pagy(authorize Dataset.filter(params).order("#{sort_column} #{sort_direction}"))
  end

  def show
    @dataset = authorize Dataset.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @dataset = @category.datasets.new
  end

  def create
    @dataset = authorize Dataset.new(dataset_params)

    if @dataset.save
      redirect_to category_datasets_url(@category)
    else
      render :new
    end
  end

  def edit
    @dataset = authorize Dataset.find(params[:id])
  end

  def update
    @dataset = authorize Dataset.find(params[:id])

    if @dataset.update(dataset_params)
      redirect_to category_datasets_url(@category)
    else
      render :edit
    end
  end

  def destroy
    @dataset = authorize Dataset.find(params[:id])
    @dataset.destroy

    redirect_to category_datasets_url(@category)
  end

  def import
    authorize Dataset, :create?

    DatasetSpreadsheet.new(@category).import(params[:file])

    redirect_to category_datasets_url(@category)
  end

  private
    def set_category
      @category = Category.find(params[:category_id])
    end

    def filter_params
      params.permit(:keyword, :province_id, :district_id, :commune_id).merge(category_id: @category.id)
    end

    def dataset_params
      params.require(:dataset).permit(:code, :name_en, :name_km,
        :commune_id, :district_id, :province_id
      ).merge(category_id: @category.id)
    end
end
