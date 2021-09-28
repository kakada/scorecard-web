# frozen_string_literal: true

module Api
  module V2
    class SessionsController < ApiController
      skip_before_action :restrict_access

      def create
        user = User.find_by(email: user_params[:email])

        if user&.valid_password?(user_params[:password])
          if user.confirmed? && user.actived?
            user.regenerate_authentication_token!

            render json: user, status: :ok
          else
            render json: { error: "Your account is unprocessable!" }, status: :unprocessable_entity
          end
        else
          render json: { error: "Invalid email or password!" }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(authentication_token: params[:authentication_token])
        user.regenerate_authentication_token!

        head :no_content
      end

      private
        def user_params
          params.require(:user).permit(:email, :password)
        end
    end
  end
end
