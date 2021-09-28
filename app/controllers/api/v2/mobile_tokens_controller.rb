# frozen_string_literal: true

module Api
  module V2
    class MobileTokensController < ApiController
      skip_before_action :restrict_access

      def update
        @token = MobileToken.find_or_initialize_by(id: token_params["id"])

        if @token.update(token_params)
          render json: @token
        else
          render json: @token.errors, status: :unprocessable_entity
        end
      end

      private
        def token_params
          params.require(:mobile_token).permit(:id, :token, :program_id, :program_uuid)
        end
    end
  end
end
