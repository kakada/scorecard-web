# frozen_string_literal: true

module Api
  module V2
    class UsersController < ApiController
      def lock_access
        current_user.lock_access!(send_instructions: false)

        head :ok
      end
    end
  end
end
