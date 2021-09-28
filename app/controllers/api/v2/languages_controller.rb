# frozen_string_literal: true

module Api
  module V2
    class LanguagesController < ApiController
      def index
        program = Program.find_by(uuid: params[:program_uuid])

        render json: program.languages
      end
    end
  end
end
