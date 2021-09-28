# frozen_string_literal: true

module Api
  module V2
    class ScorecardReferencesController < ApiController
      before_action :assign_params
      before_action :assign_scorecard

      def create
        authorize @scorecard, :submit?

        scorecard_reference = @scorecard.scorecard_references.find_or_initialize_by(uuid: reference_params[:uuid])

        if scorecard_reference.update(reference_params)
          render json: scorecard_reference, status: :created
        else
          render json: { error: scorecard_reference.errors }, status: :unprocessable_entity
        end
      end

      private
        def assign_params
          params["scorecard_reference"] = JSON.parse(params["scorecard_reference"])
        end

        def assign_scorecard
          @scorecard = Scorecard.find_by(uuid: params[:scorecard_id])

          raise ActiveRecord::RecordNotFound, with: :render_record_not_found if @scorecard.nil?
        end

        def reference_params
          params.require(:scorecard_reference).permit(:uuid, :kind).merge(attachment: params[:attachment])
        end
    end
  end
end
