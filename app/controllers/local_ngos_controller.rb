# frozen_string_literal: true

class LocalNgosController < ApplicationController
  def index
    @pagy, @local_ngos = pagy(policy_scope(authorize LocalNgo.filter(filter_params).order(sort_param)))
  end

  def show
    @local_ngo = authorize LocalNgo.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @local_ngo = authorize LocalNgo.new
  end

  def create
    @local_ngo = authorize current_program.local_ngos.new(local_ngo_params)

    if @local_ngo.save
      redirect_to local_ngos_url
    else
      render :new
    end
  end

  def edit
    @local_ngo = authorize LocalNgo.find(params[:id])
  end

  def update
    @local_ngo = authorize LocalNgo.find(params[:id])

    if @local_ngo.update(local_ngo_params)
      redirect_to local_ngos_url
    else
      render :edit
    end
  end

  def destroy
    @local_ngo = authorize LocalNgo.find(params[:id])
    @local_ngo.remove!

    redirect_to local_ngos_url
  end

  def import
    Spreadsheets::LocalNgoSpreadsheet.new(current_program).import(params[:file])

    redirect_to local_ngos_url
  end

  private
    def local_ngo_params
      params.require(:local_ngo).permit(:name, :province_id, :district_id, :commune_id, :village_id, :target_province_ids, :website_url)
    end

    def filter_params
      params.permit(:keyword).merge(program_id: current_program.try(:id))
    end
end
