# frozen_string_literal: true

module Api
  module V1
    class CafsController < ApiController
      def index
        local_ngo = LocalNgo.find(params[:local_ngo_id])

        render json: local_ngo.cafs
      end
    end
  end
end
