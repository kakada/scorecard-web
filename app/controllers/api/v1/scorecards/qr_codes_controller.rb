# frozen_string_literal: true

module Api
  module V1
    module Scorecards
      class QrCodesController < ApiController
        before_action :assign_scorecard

        def show
          authorize @scorecard, :show?

          if @scorecard.qr_code.present?
            render json: @scorecard, serializer: ScorecardQrCodeSerializer, status: :ok
          else
            render json: { error: "QR code not available" }, status: :not_found
          end
        end

        private
          def assign_scorecard
            @scorecard = Scorecard.find_by(uuid: params[:scorecard_id])

            raise ActiveRecord::RecordNotFound if @scorecard.nil?
          end
      end
    end
  end
end
