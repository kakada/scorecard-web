# frozen_string_literal: true

module Api
  module V2
    class RatingScalesController < ApiController
      def index
        program = Program.find_by(uuid: params[:program_uuid])

        render json: program.rating_scales
      end
    end
  end
end
