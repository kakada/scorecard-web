# frozen_string_literal: true

module Templates
  class IndicatorsController < ApplicationController
    helper_method :sort_column, :sort_direction
    before_action :set_template

    def index
      @pagy, @indicators = pagy(@template.indicators.order(sort_column + " " + sort_direction))
    end

    def show
      @indicator = @template.indicators.find(params[:id])
    end

    def new
      @indicator = authorize @template.indicators.new
    end

    def create
      @indicator = authorize @template.indicators.new(indicator_params)

      if @indicator.save
        redirect_to template_indicators_url(@template)
      else
        render :new
      end
    end

    def edit
      @indicator = authorize @template.indicators.find(params[:id])
    end

    def update
      @indicator = authorize @template.indicators.find(params[:id])

      if @indicator.update_attributes(indicator_params)
        redirect_to template_indicators_url(@template)
      else
        render :edit
      end
    end

    def destroy
      @indicator = authorize @template.indicators.find(params[:id])
      @indicator.destroy

      redirect_to template_indicators_url(@template)
    end

    private
      def sort_column
        Indicator.column_names.include?(params[:sort]) ? params[:sort] : default_sort_column
      end

      def indicator_params
        params.require(:indicator).permit(:tag, :name,
          languages_indicators_attributes: [ :id, :language_id, :language_code, :content, :audio, :remove_audio ]
        )
      end

      def set_template
        @template = ::Template.find(params[:template_id])
      end
  end
end
