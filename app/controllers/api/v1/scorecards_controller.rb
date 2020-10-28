# frozen_string_literal: true

module Api
  module V1
    class ScorecardsController < ApiController
      def show
        @scorecard = Scorecard.find_by(uuid: params[:id])

        render json: @scorecard
      end

      def update
        @scorecard = Scorecard.find_by(uuid: params[:id])

        if @scorecard.update(scorecard_params)
          render json: @scorecard, status: :ok
        else
          render json: { errors: @scorecard.errors }, status: :unprocessable_entity
        end
      end

      private
        def scorecard_params
          params.require(:scorecard).permit(:conducted_date,
            :number_of_caf, :number_of_participant, :number_of_female,
            scorecards_cafs_attributes: [ :id, :caf_id, :_destroy ],
            raised_indicators_attributes: [ :id, :indicatorable_id, :indicatorable_type, :raised_person_id, :_destroy ]
          )
        end
    end
  end
end
