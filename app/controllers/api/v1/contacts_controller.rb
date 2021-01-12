# frozen_string_literal: true

module Api
  module V1
    class ContactsController < ApiController
      def index
        program = Program.find_by(id: params[:program_id])

        render json: program.contacts
      end
    end
  end
end
