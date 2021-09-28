# frozen_string_literal: true

module Api
  module V2
    class ContactsController < ApiController
      def index
        render json: ContactService.new(program).as_json
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
