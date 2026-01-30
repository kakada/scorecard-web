# frozen_string_literal: true

module Scorecards
  class UnlockRequestsController < ApplicationController
    before_action :set_scorecard
    before_action :find_unlock_request, only: [:edit, :update, :approve, :reject]

    def new
      @unlock_request = authorize @scorecard.unlock_requests.new
    end

    def edit
    end

    def create
      @unlock_request = authorize @scorecard.unlock_requests.new(unlock_request_params)

      if @unlock_request.save
        flash[:notice] = t("scorecard.unlock_request_submitted")
        redirect_to scorecard_url(@scorecard.uuid)
      else
        render :new
      end
    end

    def update
      if @unlock_request.update(unlock_request_params)
        redirect_to scorecard_url(@scorecard.uuid)
      else
        render :edit
      end
    end

    def approve
      if @unlock_request.update(status: :approved, reviewer_id: current_user.id)
        flash[:notice] = t("scorecard.unlock_request_approved")
      else
        flash[:alert] = t("shared.update_failed")
      end

      redirect_to scorecard_url(@scorecard.uuid)
    end

    def reject
      if @unlock_request.update(rejected_params)
        flash[:notice] = t("scorecard.unlock_request_rejected")
      else
        flash[:alert] = t("shared.update_failed")
      end

      redirect_to scorecard_url(@scorecard.uuid)
    end

    private
      def rejected_params
        params.require(:unlock_request).permit(:rejected_reason)
          .merge(status: :rejected, reviewer_id: current_user.id)
      end

      def unlock_request_params
        params.require(:unlock_request).permit(:reason)
          .merge({ proposer_id: current_user.id })
      end

      def set_scorecard
        @scorecard = Scorecard.find_by uuid: params[:scorecard_uuid]
      end

      def find_unlock_request
        @unlock_request = authorize @scorecard.unlock_requests.find(params[:id])
      end
  end
end
