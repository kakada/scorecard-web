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
          device_submission_counts = participants
            .reject { |participant| participant.device_submission_token.blank? }
            .group_by(&:device_submission_token)
            .transform_values(&:count)
          profile_submission_counts = participants
            .group_by(&:profile_signature)
            .transform_values(&:count)

          render json: participants.map { |participant|
            profile_signature = participant.profile_signature

            {
              uuid: participant.uuid,
              age: participant.age,
              gender: participant.gender,
              disability: participant.disability,
              minority: participant.minority,
              poor_card: participant.poor_card,
              youth: participant.youth,
              submitted_at: participant.created_at,
              device_submission_token: participant.device_submission_token,
              duplicate_device_submission: device_submission_counts[participant.device_submission_token].to_i > 1,
              duplicate_device_submission_count: device_submission_counts[participant.device_submission_token].to_i,
              duplicate_profile_submission: profile_submission_counts[profile_signature].to_i > 1,
              duplicate_profile_submission_count: profile_submission_counts[profile_signature].to_i,
              ratings: participant.ratings.map { |rating|
                {
                  uuid: rating.uuid,
                  voting_indicator_uuid: rating.voting_indicator_uuid,
                  score: rating.score
                }
              }
            }
          }, status: :ok
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
