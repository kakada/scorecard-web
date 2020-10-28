# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        @pagy, @categories = pagy(current_program.categories.roots.reorder(sort_column + " " + sort_direction).includes(:children))
      }

      format.json {
        render json: current_program.categories.roots
      }
    end
  end

  def children
    @category = Category.find(params[:id])

    render json: @category.children
  end

  def new
    @category = authorize Category.new
  end

  def create
    @category = authorize current_program.categories.new(category_params)

    if @category.save
      redirect_to categories_url
    else
      render :new
    end
  end

  def edit
    @category = authorize Category.find(params[:id])
  end

  def update
    @category = authorize Category.find(params[:id])

    if @category.update_attributes(category_params)
      redirect_to categories_url
    else
      render :edit
    end
  end

  def destroy
    @category = authorize Category.find(params[:id])
    @category.destroy

    redirect_to categories_url
  end

  private
    def category_params
      params.require(:category).permit(:name, :code, :parent_id)
    end

    def sort_column
      Category.column_names.include?(params[:sort]) ? params[:sort] : default_sort_column
    end
end
