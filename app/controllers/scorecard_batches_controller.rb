# frozen_string_literal: true

class ScorecardBatchesController < ApplicationController
  before_action :set_scorecard_batch, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @scorecard_batches = pagy(current_user.scorecard_batches)
  end

  def show
  end

  def new
    @scorecard_batch = authorize ScorecardBatch.new
  end

  def create
    authorize ScorecardBatch, :create?

    if file = params[:scorecard_batch][:file].presence
      @scorecard_batch = Spreadsheets::ScorecardBatchSpreadsheet.new(current_user).import(file)

      render :import_confirm
    else
      handle_create
    end
  end

  def destroy
    @scorecard_batch.destroy

    respond_to do |format|
      format.html { redirect_to scorecard_batches_url, notice: "Scorecard batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sample
    render xlsx: "sample", filename: "scorecard_batch_sample_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
  end

  private
    def set_scorecard_batch
      @scorecard_batch = authorize ScorecardBatch.find_by(code: params[:code])
    end

    def scorecard_batch_params
      params.require(:scorecard_batch).permit(
        :total_item, :total_valid, :total_province,
          :total_district, :total_commune,
          scorecards_attributes: [
            :year, :unit_type_id, :facility_id, :scorecard_type,
            :province_id, :district_id, :commune_id,
            :primary_school_code, :local_ngo_id, :program_id,
            :planned_start_date, :planned_end_date, :creator_id, :_destroy
          ]
        ).merge({
          user_id: current_user.id,
          program_id: current_user.program_id
        })
    end

    def handle_create
      @scorecard_batch = ScorecardBatch.new(scorecard_batch_params)

      if @scorecard_batch.save
        redirect_to scorecard_batch_url(@scorecard_batch.code), notice: "Scorecard batch was successfully imported."
      else
        render :import_confirm
      end
    end
end
