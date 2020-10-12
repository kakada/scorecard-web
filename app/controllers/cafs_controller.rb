# frozen_string_literal: true

class CafsController < ApplicationController
  def index
    @pagy, @cafs = pagy(current_program.cafs)
  end

  def new
    @caf = authorize Caf.new
  end

  def create
    @caf = authorize current_program.cafs.new(caf_params)

    if @caf.save
      redirect_to cafs_url
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
      redirect_to cafs_url
    else
      render :edit
    end
  end

  def destroy
    @caf = authorize Caf.find(params[:id])
    @caf.destroy

    redirect_to cafs_url
  end

  private
    def caf_params
      params.require(:caf).permit(:name, :province_id, :district_id, :commune_id, :address)
    end
end
