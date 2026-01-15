# frozen_string_literal: true

module Api
  module V1
    module Scorecards
      class PollsController < ApiController
        before_action :assign_scorecard

        def show
          authorize @scorecard, :show?

          render json: {
            total_votes: @scorecard.ratings.distinct.count(:participant_uuid)
          }, status: :ok
        end

        private
          def assign_scorecard
            @scorecard = Scorecard.find_by!(uuid: params[:scorecard_id])
          end
      end
    end
  end
end
