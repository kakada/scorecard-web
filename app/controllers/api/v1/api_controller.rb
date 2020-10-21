# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::Base
      before_action :authenticate_with_token!

      def current_user
        @current_user ||= User.from_authentication_token(request.headers["Authorization"])
      end
      helper_method :current_user

      private
        def authenticate_with_token!
          render json: { errors: "Not authenticated" }, status: :unauthorized unless current_user.present?
        end
    end
  end
end
