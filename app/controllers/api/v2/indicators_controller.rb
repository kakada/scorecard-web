# frozen_string_literal: true

module Api
  module V2
    class IndicatorsController < ApiController
      def index
        facility = Facility.find(params[:facility_id])

        render json: facility.indicators
      end
    end
  end
end
