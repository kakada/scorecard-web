# frozen_string_literal: true

module LocalNgos
  class CafsController < ApplicationController
    helper_method :filter_params
    before_action :set_local_ngo

    def index
      respond_to do |format|
        format.html {
          @pagy, @cafs = pagy(authorize Caf.filter(filter_params).order(sort_param).includes(:educational_background, :scorecard_knowledges))
        }

        format.xlsx {
          @cafs = authorize Caf.filter(filter_params).order(sort_param).includes(:educational_background, :scorecard_knowledges)

          if @cafs.length > Settings.max_download_record
            flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
            redirect_to local_ngo_cafs_url(@local_ngo)
          else
            render xlsx: "index", filename: "caf_in_#{@local_ngo.name}_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
          end
        }
      end
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

    private
      def set_local_ngo
        @local_ngo = authorize ::LocalNgo.find(params[:local_ngo_id]), :manage_caf?
      end

      def caf_params
        params.require(:caf).permit(
          :name, :sex, :date_of_birth, :tel, :actived, :province_id, :district_id, :commune_id,
          :educational_background_id, scorecard_knowledge_ids: []
        )
      end

      def filter_params
        params.permit(:keyword).merge(local_ngo_id: @local_ngo.id)
      end
  end
end
