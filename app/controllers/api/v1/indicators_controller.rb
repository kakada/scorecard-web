# frozen_string_literal: true

module Api
  module V1
    class IndicatorsController < ApiController
      def index
        facility = Facility.find(params[:facility_id])

        render json: facility.indicators.predefines
      end
    end
  end
end
