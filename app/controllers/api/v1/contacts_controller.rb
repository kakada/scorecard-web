# frozen_string_literal: true

module Api
  module V1
    class ContactsController < ApiController
      def index
        @contact = ContactService.new(program)
        render json: @contact.as_json
      end

      private

      def program
        current_user && current_user.program
      end

      def restrict_access
        super rescue nil
      end
    end
  end
end
