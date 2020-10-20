# frozen_string_literal: true

module Api
  module V1
    class ScorecardsController < ApiController
      def show
        @scorecard = Scorecard.find_by(uuid: params[:uuid])

        render json: @scorecard
      end
    end
  end
end
