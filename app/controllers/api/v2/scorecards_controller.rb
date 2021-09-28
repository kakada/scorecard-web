# frozen_string_literal: true

module Api
  module V2
    class ScorecardsController < ApiController
      before_action :assign_scorecard

      def show
        authorize @scorecard, :download?

        render json: @scorecard
      end

      def update
        authorize @scorecard, :submit?

        if @scorecard.update(scorecard_params)
          @scorecard.lock_access!
          render json: @scorecard, status: :ok
        else
          render json: { errors: @scorecard.errors }, status: :unprocessable_entity
        end
      end

      private
        def assign_scorecard
          @scorecard = Scorecard.find_by(uuid: params[:id])

          raise ActiveRecord::RecordNotFound, with: :render_record_not_found if @scorecard.nil?
        end

        def scorecard_params
          params.require(:scorecard).permit(
            :conducted_date, :number_of_caf, :number_of_participant, :number_of_female,
            :number_of_disability, :number_of_ethnic_minority, :number_of_youth, :number_of_id_poor,
            :finished_date, :language_conducted_code, :running_date,
            facilitators_attributes: [ :id, :caf_id, :position, :scorecard_uuid ],
            participants_attributes: [ :uuid, :age, :gender, :disability, :minority, :youth, :poor_card, :scorecard_uuid ],
            raised_indicators_attributes: [
              :uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :scorecard_uuid, tag_attributes: [:name]
            ],
            voting_indicators_attributes: [
              :uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :scorecard_uuid,
              :median, strength: [], weakness: [], suggested_action: [],
              suggested_actions_attributes: [ :voting_indicator_uuid, :scorecard_uuid, :content, :selected ]
            ],
            ratings_attributes: [ :id, :voting_indicator_uuid, :participant_uuid, :scorecard_uuid, :score ],
          )
        end
    end
  end
end
