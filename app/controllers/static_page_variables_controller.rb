# frozen_string_literal: true

class StaticPageVariablesController < ApplicationController
  before_action :set_static_page_variable, only: [:show, :edit, :update, :destroy]

  def index
    authorize StaticPageVariable
    @pagy, @static_page_variables = pagy(policy_scope(StaticPageVariable.order(updated_at: :desc)))
  end

  def new
    @static_page_variable = authorize StaticPageVariable.new
  end

  def show
    respond_to do |format|
      format.html { redirect_to static_page_variables_path }
      format.js
    end
  end

  def create
    @static_page_variable = authorize StaticPageVariable.new(static_page_variable_params)

    if @static_page_variable.save
      redirect_to static_page_variables_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @static_page_variable.update(static_page_variable_params)
      redirect_to static_page_variables_path
    else
      render :edit
    end
  end

  def destroy
    @static_page_variable.destroy

    redirect_to static_page_variables_path
  end

  private
    def set_static_page_variable
      @static_page_variable = authorize StaticPageVariable.find(params[:id])
    end

    def static_page_variable_params
      params.require(:static_page_variable).permit(:key, :variable_type, :value, :image, :description)
    end
end
