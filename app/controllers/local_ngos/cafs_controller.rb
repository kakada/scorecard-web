# frozen_string_literal: true

module LocalNgos
  class CafsController < ApplicationController
    before_action :set_local_ngo

    def index
      @pagy, @cafs = pagy(authorize Caf.filter(filter_params).order(sort_param).includes(:educational_background, :scorecard_knowledges))
    end

    def show
      @caf = authorize Caf.find(params[:id])

      respond_to do |format|
        format.js
      end
    end

    def new
      @caf = authorize Caf.new
    end

    def create
      @caf = authorize @local_ngo.cafs.new(caf_params)

      if @caf.save
        redirect_to local_ngo_cafs_url(@local_ngo)
      else
        render :new
      end
    end

    def edit
      @caf = authorize Caf.find(params[:id])
    end

    def update
      @caf = authorize Caf.find(params[:id])

      if @caf.update(caf_params)
        redirect_to local_ngo_cafs_url(@local_ngo)
      else
        render :edit
      end
    end

    def destroy
      @caf = authorize Caf.find(params[:id])
      @caf.destroy

      redirect_to local_ngo_cafs_url(@local_ngo)
    end

    def import
      Spreadsheets::CafSpreadsheet.new(@local_ngo).import(params[:file])

      redirect_to local_ngo_cafs_url(@local_ngo)
    end

    private
      def set_local_ngo
        @local_ngo = authorize ::LocalNgo.find(params[:local_ngo_id]), :manage_caf?
      end

      def caf_params
        params.require(:caf).permit(
          :name, :sex, :date_of_birth, :tel, :address, :actived,
          :educational_background_id, scorecard_knowledge_ids: []
        )
      end

      def filter_params
        params.permit(:keyword).merge(local_ngo_id: @local_ngo.id)
      end
  end
end
