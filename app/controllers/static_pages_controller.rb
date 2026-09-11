# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :set_static_page, only: [:show, :edit, :update, :destroy]

  def index
    authorize StaticPage
    @pagy, @static_pages = pagy(policy_scope(StaticPage.order(updated_at: :desc)))
  end

  def show
  end

  def new
    @static_page = authorize StaticPage.new
  end

  def create
    @static_page = authorize StaticPage.new(static_page_params)

    if @static_page.save
      redirect_to static_page_path(@static_page)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @static_page.update(static_page_params)
      redirect_to static_page_path(@static_page)
    else
      render :edit
    end
  end

  def destroy
    @static_page.destroy

    redirect_to static_pages_path
  end

  private
    def set_static_page
      @static_page = authorize StaticPage.find(params[:id])
    end

    def static_page_params
      params.require(:static_page).permit(:slug, :content_en, :content_km)
    end
end
