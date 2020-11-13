# frozen_string_literal: true

module Api
  module V1
    class CustomIndicatorsController < ApiController
      def create
        scorecard = Scorecard.find_by(uuid: params[:scorecard_id])
        custom_indicator = scorecard.custom_indicators.new(custom_indicator_params)

        if custom_indicator.save
          render json: custom_indicator, status: :created
        else
          render json: { errors: custom_indicator.errors }, status: :unprocessable_entity
        end
      end

      private
        def custom_indicator_params
          params.require(:custom_indicator).permit(:id, :name, :audio, tag_attributes: [:id, :name])
        end
    end
  end
end
