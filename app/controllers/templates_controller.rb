# frozen_string_literal: true

class TemplatesController < ApplicationController
  def index
    @pagy, @templates = pagy(current_program.templates.order(sort_column + " " + sort_direction).includes(:indicators))
  end

  def show
    @template = authorize ::Template.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @template = authorize ::Template.new
  end

  def create
    @template = authorize current_program.templates.new(template_params)

    if @template.save
      redirect_to templates_url
    else
      render :new
    end
  end

  def edit
    @template = authorize ::Template.find(params[:id])
  end

  def update
    @template = authorize ::Template.find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to templates_url
    else
      render :edit
    end
  end

  def destroy
    @template = authorize ::Template.find(params[:id])
    @template.destroy

    redirect_to templates_url
  end

  private
    def template_params
      params.require(:template).permit(:name,
        indicators_attributes: [
          :id, :name, :display_order, :_destroy, :image, :remove_image,
          languages_indicators_attributes: [ :id, :language_id, :language_code, :content, :audio, :remove_audio ],
          tag_attributes: [ :id, :name ]
        ]
      )
    end
end
