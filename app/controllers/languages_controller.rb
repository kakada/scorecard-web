# frozen_string_literal: true

class LanguagesController < ApplicationController
  def index
    @pagy, @languages = pagy(policy_scope(authorize current_program.languages.order(sort_column + " " + sort_direction)))
  end

  def new
    @language = authorize Language.new
  end

  def create
    @language = authorize current_program.languages.new(language_params)

    respond_to do |format|
      if @language.save
        format.js { redirect_to languages_path }
      else
        format.js
      end
    end
  end

  def edit
    @language = authorize Language.find(params[:id])
  end

  def update
    @language = authorize Language.find(params[:id])

    respond_to do |format|
      if @language.update(language_params)
        format.js { redirect_to languages_path }
      else
        format.js
      end
    end
  end

  def destroy
    @language = authorize Language.find(params[:id])
    @language.destroy

    redirect_to languages_url
  end

  private
    def language_params
      params.require(:language).permit(:code, :name)
    end
end
