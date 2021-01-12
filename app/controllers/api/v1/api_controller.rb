# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::Base
      protect_from_forgery with: :null_session

      before_action :restrict_access

      attr_reader :current_user
      helper_method :current_user

      private
        def restrict_access
          authenticate_or_request_with_http_token do |token, _options|
            @current_user = User.from_authentication_token(token)
            @current_user.present? && !@current_user.access_locked?
          end
        end
    end
  end
end
