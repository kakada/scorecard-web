# frozen_string_literal: true

class PdfTemplatesController < ApplicationController
  def index
    @pagy, @pdf_templates = pagy(authorize current_program.pdf_templates.order(sort_column + " " + sort_direction))
  end

  def new
    @pdf_template = current_program.pdf_templates.new
  end

  def show
    @pdf_template = authorize PdfTemplate.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def edit
    @pdf_template = PdfTemplate.find(params[:id])
  end

  def create
    @pdf_template = authorize current_program.pdf_templates.new(pdf_template_params)

    if @pdf_template.save
      redirect_to pdf_templates_url
    else
      render :new
    end
  end

  def preview
    @pdf_template = authorize PdfTemplate.find(params[:pdf_template_id]), :index?

    render pdf: "pdf_template_#{@pdf_template.name}",
           inline: PdfTemplateSampleInterpreter.new(@pdf_template.id).interpreted_message
  end

  def update
    @pdf_template = authorize PdfTemplate.find(params[:id])

    if @pdf_template.update_attributes(pdf_template_params)
      redirect_to pdf_templates_url
    else
      render :edit
    end
  end

  def destroy
    @pdf_template = authorize PdfTemplate.find(params[:id])
    @pdf_template.destroy

    redirect_to pdf_templates_url
  end

  private
    def pdf_template_params
      params.require(:pdf_template).permit(:name, :content, :language_code)
    end
end
