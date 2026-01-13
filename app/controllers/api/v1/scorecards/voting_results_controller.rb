# frozen_string_literal: true

module Api
  module V1
    module Scorecards
      class VotingResultsController < ApiController
        before_action :assign_scorecard

        def index
          authorize @scorecard, :download?

          voting_indicators = @scorecard.voting_indicators.order(:display_order).to_a
          rating_counts = Rating
            .where(voting_indicator_uuid: voting_indicators.map(&:uuid))
            .group(:voting_indicator_uuid, :score)
            .count

          render json: voting_indicators,
            each_serializer: VotingResultsSerializer,
            status: :ok,
            rating_counts: rating_counts
        end

        private
          def assign_scorecard
            @scorecard = Scorecard.find_by!(uuid: params[:scorecard_id])
          end
      end
    end
  end
end
