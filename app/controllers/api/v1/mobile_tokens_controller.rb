# frozen_string_literal: true

module Api
  module V1
    class MobileTokensController < ApiController
      skip_before_action :restrict_access

      def update
        @token = MobileToken.find_or_initialize_by(device_id: token_params["device_id"])

        if @token.update(token_params)
          render json: @token
        else
          render json: @token.errors, status: :unprocessable_entity
        end
      end

      private
        def token_params
          params.require(:mobile_token).permit(
            :token, :program_id, :device_id, :device_type, :app_version
          )
        end
    end
  end
end
