# frozen_string_literal: true

module Api
  module V1
    class ContactsController < ApiController
      def index
        program = current_user.program

        render json: program.try(:contacts) || []
      end
    end
  end
end
