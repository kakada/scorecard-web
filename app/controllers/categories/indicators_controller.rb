# frozen_string_literal: true
module Categories
  class IndicatorsController < ApplicationController
    helper_method :sort_column, :sort_direction
    before_action :set_category

    def index
      @pagy, @indicators = pagy(@category.indicators.order(sort_column + " " + sort_direction))
    end

    def show
      @indicator = @category.indicators.find(params[:id])
    end

    def new
      @indicator = authorize @category.indicators.new
    end

    def create
      @indicator = authorize @category.indicators.new(indicator_params)

      if @indicator.save
        redirect_to category_indicators_url(@category)
      else
        render :new
      end
    end

    def edit
      @indicator = authorize @category.indicators.find(params[:id])
    end

    def update
      @indicator = authorize @category.indicators.find(params[:id])

      if @indicator.update_attributes(indicator_params)
        redirect_to category_indicators_url(@category)
      else
        render :edit
      end
    end

    def destroy
      @indicator = authorize @category.indicators.find(params[:id])
      @indicator.destroy

      redirect_to category_indicators_url(@category)
    end

    def clone_from_template
      ::IndicatorService.new(params[:category_id]).clone_from_template(params[:template_id])

      redirect_to category_indicators_url(@category)
    end

    def clone_to_template
      ::IndicatorService.new(params[:category_id]).clone_to_template(params[:template_name])

      redirect_to templates_url
    end

    private
      def sort_column
        Indicator.column_names.include?(params[:sort]) ? params[:sort] : "name"
      end

      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
      end

      def indicator_params
        params.require(:indicator).permit(:tag, :name,
          languages_indicators_attributes: [ :id, :language_id, :language_code, :content, :audio, :remove_audio ]
        )
      end

      def set_category
        @category = Category.find(params[:category_id])
      end
  end
end
