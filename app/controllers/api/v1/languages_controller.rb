# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApiController
      def index
        program = Program.find_by(id: params[:program_id])

        render json: program.languages
      end
    end
  end
end
