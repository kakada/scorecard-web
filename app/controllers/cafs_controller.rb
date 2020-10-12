# frozen_string_literal: true

class CafsController < ApplicationController
  before_action :set_local_ngo

  def index
    @pagy, @cafs = pagy(@local_ngo.cafs)
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

    if @caf.update_attributes(caf_params)
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
      @local_ngo = ::LocalNgo.find(params[:local_ngo_id])
    end

    def caf_params
      params.require(:caf).permit(:name, :sex, :date_of_birth, :tel, :address)
    end
end
