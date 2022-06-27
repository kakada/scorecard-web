# frozen_string_literal: true

module Facilities
  class IndicatorActionsController < ApplicationController
    before_action :set_indicator, except: [:import]

    def index
      @pagy, @indicator_actions = pagy(authorize IndicatorAction.filter(filter_params).predefineds)
    end

    def show
      @indicator_action = authorize @indicator.indicator_actions.find(params[:id])
    end

    def new
      @indicator_action = authorize @indicator.indicator_actions.new
    end

    def create
      @indicator_action = authorize @indicator.indicator_actions.new(indicator_action_params)

      if @indicator_action.save
        redirect_to indicator_indicator_actions_path(@indicator)
      else
        render :new
      end
    end

    def edit
      @indicator_action = authorize @indicator.indicator_actions.find(params[:id])
    end

    def update
      @indicator_action = authorize @indicator.indicator_actions.find(params[:id])

      if @indicator_action.update(indicator_action_params)
        redirect_to indicator_indicator_actions_path(@indicator)
      else
        render :edit
      end
    end

    def import
      authorize IndicatorAction, :create?

      Spreadsheets::IndicatorActionSpreadsheet.new.import(params[:file])

      redirect_to facility_indicators_url(facility)
    end

    def destroy
      @indicator_action = @indicator.indicator_actions.find(params[:id])
      @indicator_action.destroy

      redirect_to indicator_indicator_actions_path(@indicator)
    end

    private
      def set_indicator
        @indicator = Indicator.find(params[:indicator_id])
      end

      def facility
        @facility ||= Facility.find(params[:facility_id])
      end

      def indicator_action_params
        params.require(:indicator_action).permit(
          :name, :code, :kind
        )
      end

      def filter_params
        params.permit(:name, :kind)
              .merge(indicator_uuid: @indicator.uuid)
      end
  end
end
