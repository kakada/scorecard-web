# frozen_string_literal: true

class CafImportersController < ApplicationController
  before_action :set_local_ngo
  before_action :set_caf_batch, only: [:edit, :update, :destroy]

  def index
    @pagy, @batches = pagy(authorize CafBatch.filter(filter_params).order(updated_at: :desc).includes(:cafs))
  end

  def new
    @batch = authorize CafBatch.new
  end

  def create
    authorize CafBatch, :create?

    if file = params[:caf_batch][:file].presence
      @batch = Spreadsheets::CafBatchSpreadsheet.new(@local_ngo).import(file)

      render :wizard_review, status: :see_other
    else
      create_caf_batch
    end
  end

  def sample
    render xlsx: "sample", filename: "caf_batch_sample_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
  end

  private
    def set_caf_batch
      @batch = authorize CafBatch.find_by(code: params[:code])
    end

    def create_caf_batch
      @batch = CafBatch.new(caf_batch_params)

      if @batch.save
        redirect_to local_ngo_cafs_url(@local_ngo), notice: I18n.t("caf.import_success", count: @batch.cafs.length)
      else
        redirect_to new_local_ngo_caf_importer_url(@local_ngo), alert: I18n.t("caf.some_invalid_records")
      end
    end

    def caf_batch_params
      params.require(:caf_batch).permit(
        :total_count, :valid_count, :reference_cache,
        importing_cafs_attributes: [
          :caf_id,
          caf_attributes: [
            :id, :name, :sex, :date_of_birth, :tel, :commune_id, :district_id, :local_ngo_id,
            :province_id, :educational_background_id, scorecard_knowledge_ids: []
          ]
        ]
      ).merge({
        user_id: current_user.id
      })
    end

    def filter_params
      params.permit(:keyword)
    end

    def set_local_ngo
      @local_ngo = LocalNgo.find(params[:local_ngo_id])
    end
end
