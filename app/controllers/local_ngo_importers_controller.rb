# frozen_string_literal: true

class LocalNgoImportersController < ApplicationController
  before_action :set_local_ngo_batch, only: [:edit, :update, :destroy]

  def index
    @pagy, @batches = pagy(policy_scope(authorize LocalNgoBatch.filter(filter_params).order(updated_at: :desc)))
  end

  def new
    @batch = authorize LocalNgoBatch.new
  end

  def create
    authorize LocalNgoBatch, :create?

    if file = params[:local_ngo_batch][:file].presence
      @batch = Spreadsheets::LocalNgoBatchSpreadsheet.new(current_user).import(file)

      render :wizard_review, status: :see_other
    else
      create_local_ngo_batch
    end
  end

  def sample
    render xlsx: "sample", filename: "local_ngo_batch_sample_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
  end

  private
    def set_local_ngo_batch
      @batch = authorize LocalNgoBatch.find_by(code: params[:code])
    end

    def create_local_ngo_batch
      @batch = LocalNgoBatch.new(local_ngo_batch_params)

      if @batch.save
        redirect_to local_ngos_url(@local_ngo), notice: I18n.t("shred.import_success", count: @batch.local_ngos.length)
      else
        redirect_to new_local_ngo_importer_url(@local_ngo), alert: I18n.t("shared.some_invalid_records")
      end
    end

    def local_ngo_batch_params
      params.require(:local_ngo_batch).permit(
        :total_count, :valid_count, :reference_cache,
        local_ngos_attributes: [
          :name, :province_id, :district_id, :commune_id, :village_id, :program_id
        ]
      ).merge({
        user_id: current_user.id,
        program_id: current_program.id
      })
    end

    def filter_params
      params.permit(:keyword)
    end
end
