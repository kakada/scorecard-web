# frozen_string_literal: true

class JaapsController < ApplicationController
  before_action :set_jaap, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @jaaps = pagy(policy_scope(Jaap.all.order(created_at: :desc)))
  end

  def new
    @jaap = authorize Jaap.new
  end

  def create
    @jaap = authorize Jaap.new(jaap_params)
    if @jaap.save
      redirect_to @jaap, notice: "JAAP saved!"
    else
      render :new
    end
  end

  def edit
    authorize @jaap
  end

  def update
    authorize @jaap
    if @jaap.update(jaap_params)
      redirect_to @jaap, notice: "JAAP updated!"
    else
      render :edit
    end
  end

  def show
    authorize @jaap
  end

  def destroy
    @jaap.destroy
    redirect_to jaaps_path, notice: "JAAP deleted!"
  end

  private
    def set_jaap
      @jaap = authorize Jaap.find(params[:id])
    end

    def jaap_params
      params.require(:jaap).permit(:province_id, :district_id, :commune_id, :data, :reference, :reference_cache, :remove_reference).merge(program_id: current_user.program_id)
    end
end
