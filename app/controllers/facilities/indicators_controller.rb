# frozen_string_literal: true

module Facilities
  class IndicatorsController < ApplicationController
    before_action :set_facility

    def index
      respond_to do |format|
        format.html {
          @pagy, @indicators = pagy(Indicators::PredefineIndicator.filter(filter_params).includes(:tag, :raised_indicators, :voting_indicators).order(sort_column + " " + sort_direction))
          @templates = current_program.templates.includes(:indicators)
        }

        format.xlsx {
          @indicators = Indicators::PredefineIndicator.filter(filter_params).includes(:indicator_actions).order(sort_column + " " + sort_direction)

          if @indicators.length > Settings.max_download_scorecard_record
            flash[:alert] = t("scorecard.file_size_is_too_big")
            redirect_to facility_indicators_url(@facility)
          else
            render xlsx: "index", filename: "indicators_in_#{@facility.name}_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
          end
        }
      end
    end

    def show
      @indicator = @facility.indicators.find(params[:id])

      respond_to do |format|
        format.js
      end
    end

    def new
      @indicator = authorize @facility.indicators.new
    end

    def create
      @indicator = authorize @facility.indicators.new(indicator_params)

      if @indicator.save
        redirect_to facility_indicators_url(@facility)
      else
        render :new
      end
    end

    def edit
      @indicator = authorize @facility.indicators.find(params[:id])
    end

    def update
      @indicator = authorize @facility.indicators.find(params[:id])

      if @indicator.update(indicator_params)
        redirect_to facility_indicators_url(@facility)
      else
        render :edit
      end
    end

    def destroy
      @indicator = authorize @facility.indicators.find(params[:id])
      @indicator.destroy

      redirect_to facility_indicators_url(@facility)
    end

    def clone_from_template
      ::IndicatorService.new(params[:facility_id]).clone_from_template(params[:template_id])

      redirect_to facility_indicators_url(@facility)
    end

    def clone_to_template
      ::IndicatorService.new(params[:facility_id]).clone_to_template(params[:template_name])

      redirect_to templates_url
    end

    def import
      ::IndicatorService.new(params[:facility_id]).import(params[:file])

      redirect_to facility_indicators_url(@facility)
    end

    private
      def indicator_params
        params.require(:indicator).permit(:name,
          languages_indicators_attributes: [ :id, :language_id, :language_code, :content, :audio, :remove_audio ],
          tag_attributes: [:id, :name, :_distroy]
        )
      end

      def filter_params
        params.permit(:name).merge({ facility_id: @facility.id })
      end

      def set_facility
        @facility = Facility.find(params[:facility_id])
      end
  end
end
