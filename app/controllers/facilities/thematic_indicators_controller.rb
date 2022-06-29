# frozen_string_literal: true

module Facilities
  class ThematicIndicatorsController < ApplicationController
    before_action :set_facility

    def index
      @indicators = authorize Indicators::PredefineIndicator.filter(filter_params).includes(:thematic)
      @thematics = Thematic.all

      respond_to do |format|
        format.xlsx
      end
    end

    def import
      authorize Indicator, :create?

      Spreadsheets::ThematicIndicatorSpreadsheet.new.import(params[:file])

      redirect_to facility_indicators_url(@facility)
    end

    private
      def set_facility
        @facility = Facility.find(params[:facility_id])
      end

      def filter_params
        params.permit(:name).merge({ facility_id: @facility.id })
      end
  end
end
