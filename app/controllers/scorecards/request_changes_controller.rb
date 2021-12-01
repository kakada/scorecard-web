# frozen_string_literal: true

module Scorecards
  class RequestChangesController < ApplicationController
    before_action :set_scorecard
    before_action :find_request_change, only: [:edit, :update, :approve, :reject]

    def new
      @request_change = authorize @scorecard.request_changes.new
    end

    def edit
    end

    def create
      @request_change = authorize @scorecard.request_changes.new(request_change_params)

      if @request_change.save
        flash[:notice] = t("scorecard.create_successfully")
        redirect_to scorecard_url(@scorecard.uuid)
      else
        render :new
      end
    end

    def update
      if @request_change.update(request_change_params)
        redirect_to scorecard_url(@scorecard.uuid)
      else
        render :edit
      end
    end

    def approve
      @request_change.update(status: :approved, reviewer_id: current_user.id)

      redirect_to scorecard_url(@scorecard.uuid)
    end

    def reject
      @request_change.update(rejected_params)

      redirect_to scorecard_url(@scorecard.uuid)
    end

    private
      def rejected_params
        params.require(:request_change).permit(:rejected_reason)
          .merge(status: :rejected, reviewer_id: current_user.id)
      end

      def request_change_params
        params.require(:request_change).permit(:year, :scorecard_type, :changed_reason,
          :province_id, :district_id, :commune_id, :primary_school_code
        ).merge({ proposer_id: current_user.id })
      end

      def set_scorecard
        @scorecard = Scorecard.find_by uuid: params[:scorecard_uuid]
      end

      def find_request_change
        @request_change = authorize @scorecard.request_changes.find(params[:id])
      end
  end
end
