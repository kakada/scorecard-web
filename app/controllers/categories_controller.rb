# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @categories = pagy(authorize Category.order("#{sort_column} #{sort_direction}"))
  end

  def show
  end

  def new
    @category = authorize Category.new
  end

  def create
    @category = authorize Category.new(category_params)

    if @category.save
      redirect_to categories_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url
    else
      render :edit
    end
  end

  def destroy
    @category.destroy

    redirect_to categories_url
  end

  private
    def category_params
      params.require(:category).permit(:code, :name_en, :name_km, hierarchy: [])
    end

    def set_category
      @category = authorize Category.find(params[:id])
    end
end
