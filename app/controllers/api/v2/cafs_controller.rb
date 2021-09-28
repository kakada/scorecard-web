# frozen_string_literal: true

module Api
  module V2
    class CafsController < ApiController
      def index
        local_ngo = LocalNgo.find(params[:local_ngo_id])

        render json: local_ngo.cafs.actives
      end
    end
  end
end
