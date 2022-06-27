# frozen_string_literal: true

module Api
  module V1
    class IndicatorsController < ApiController
      def index
        facility = Facility.find(params[:facility_id])

        render json: facility.indicators.predefines.includes(:tag, :languages_indicators, :indicator_actions)
      end
    end
  end
end
