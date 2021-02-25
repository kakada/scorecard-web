# frozen_string_literal: true

module Api
  module V1
    class ScorecardsController < ApiController
      def show
        @scorecard = Scorecard.find_by(uuid: params[:id])

        render json: @scorecard
      end

      def update
        @scorecard = authorize Scorecard.find_by(uuid: params[:id])

        if @scorecard.update(scorecard_params)
          @scorecard.lock_access!
          render json: @scorecard, status: :ok
        else
          render json: { errors: @scorecard.errors }, status: :unprocessable_entity
        end
      end

      private
        def scorecard_params
          params.require(:scorecard).permit(
            :conducted_date, :number_of_caf, :number_of_participant, :number_of_female,
            :number_of_disability, :number_of_ethnic_minority, :number_of_youth, :number_of_id_poor,
            facilitators_attributes: [ :id, :caf_id, :position, :scorecard_uuid ],
            participants_attributes: [ :uuid, :age, :gender, :disability, :minority, :youth, :poor_card, :scorecard_uuid ],
            raised_indicators_attributes: [
              :uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :scorecard_uuid, tag_attributes: [:name]
            ],
            voting_indicators_attributes: [
              :uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :scorecard_uuid,
              :median, strength: [], weakness: [], suggested_action: []
            ],
            ratings_attributes: [ :id, :voting_indicator_uuid, :participant_uuid, :scorecard_uuid, :score ],
          )
        end
    end
  end
end
