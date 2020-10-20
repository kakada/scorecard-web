# frozen_string_literal: true

module Api
  module V1
    class ScorecardsController < ApiController
      def show
        @scorecard = Scorecard.find_by(uuid: params[:id])

        render json: @scorecard
      end

      def update
      end
    end
  end
end
