class LanguagesController < ApplicationController
  def index
    @pagy, @languages = pagy(Language.all)
  end

  def new
    @language = authorize Language.new
  end

  def create
    @language = authorize current_program.languages.new(language_params)

    if @language.save
      redirect_to languages_url
    else
      render :new
    end
  end

  def edit
    @language = authorize Language.find(params[:id])
  end

  def update
    @language = authorize Language.find(params[:id])

    if @language.update_attributes(language_params)
      redirect_to languages_url
    else
      render :edit
    end
  end

  def destroy
    @language = authorize Language.find(params[:id])
    @language.destroy

    redirect_to programs_url
  end

  private
    def language_params
      params.require(:language).permit(:code, :name)
    end
end
