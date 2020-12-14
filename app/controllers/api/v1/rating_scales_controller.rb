# frozen_string_literal: true

module Api
  module V1
    class RatingScalesController < ApiController
      def index
        program = Program.find(params[:program_id])

        render json: program.rating_scales
      end
    end
  end
end
