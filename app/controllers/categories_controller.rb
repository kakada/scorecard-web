class CategoriesController < ApplicationController
  def index
    @pagy, @categories = pagy(Category.roots)
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
      params.require(:category).permit(:name, :parent_id)
    end
end
