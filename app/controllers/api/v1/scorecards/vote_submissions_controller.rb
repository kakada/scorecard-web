# frozen_string_literal: true

module Api
  module V1
    module Scorecards
      class VoteSubmissionsController < ApiController
        before_action :assign_scorecard
        before_action :assign_participant, only: :destroy

        def index
          authorize @scorecard, :download?

          participants = @scorecard.participants.includes(:ratings).order(:created_at)

          render json: participants, each_serializer: VotingSubmissionSerializer, status: :ok
        end

        def destroy
          authorize @scorecard, :submit?

          @participant.destroy!
          head :no_content
        end

        private
          def assign_scorecard
            @scorecard = Scorecard.find_by!(uuid: params[:scorecard_id])
          end

          def assign_participant
            @participant = @scorecard.participants.find_by!(uuid: params[:id])
          end
      end
    end
  end
end
