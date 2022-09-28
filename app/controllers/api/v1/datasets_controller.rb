# frozen_string_literal: true

module Api
  module V1
    class DatasetsController < ApiController
      skip_before_action :restrict_access

      def index
        @datasets = Dataset.filter(dataset_params)

        render json: @datasets
      end

      private
        def dataset_params
          params.permit(:commune_id, :district_id, :province_id, :category_id)
        end
    end
  end
end
