# frozen_string_literal: true

module Api
  module V1
    class IndicatorsController < ApiController
      def index
        category = Category.find(params[:category_id])

        render json: category.indicators
      end
    end
  end
end
