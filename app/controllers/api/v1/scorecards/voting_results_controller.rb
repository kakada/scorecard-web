# frozen_string_literal: true

module Api
  module V1
    module Scorecards
      class VotingResultsController < ApiController
        before_action :assign_scorecard

        def index
          authorize @scorecard, :download?
          @voting_indicators = @scorecard.voting_indicators.order(:display_order)

          render json: @voting_indicators, each_serializer: VotingResultsSerializer, status: :ok
        end

        private
          def assign_scorecard
            @scorecard = Scorecard.find_by!(uuid: params[:scorecard_id])
          end
      end
    end
  end
end
