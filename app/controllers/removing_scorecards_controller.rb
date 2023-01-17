# frozen_string_literal: true

class RemovingScorecardsController < ApplicationController
  def index
    @pagy, @batches = pagy(RemovingScorecardBatch.order(updated_at: :desc).includes(:scorecards, :user))
  end

  def new
    @batch = authorize RemovingScorecardBatch.new
  end

  def create
    authorize RemovingScorecardBatch, :create?

    if file = params[:removing_scorecard_batch][:file].presence
      @batch = Spreadsheets::RemovingScorecardBatchSpreadsheet.new(current_user).import(file)

      render :wizard_review
    else
      handle_create
    end
  end

  private
    def removing_scorecard_batch_params
      params.require(:removing_scorecard_batch)
        .permit(:total_count, :valid_count, :filename,
          :reference_cache, :confirm_removing_scorecard_codes,
          removing_scorecard_codes: []
        ).merge({
          user_id: current_user.id,
          program_id: current_user.program_id
        })
    end

    def handle_create
      @batch = RemovingScorecardBatch.new(removing_scorecard_batch_params)

      if @batch.save
        redirect_to scorecards_url, notice: "#{@batch.removing_scorecard_codes.length} Scorecards was successfully removed from the system."
      else
        redirect_to new_removing_scorecard_url, alert: "There are some invalid records, please check and reimport!"
      end
    end
end
