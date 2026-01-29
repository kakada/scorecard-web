# frozen_string_literal: true

class JaapsController < ApplicationController
  before_action :set_jaap, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @jaaps = pagy(policy_scope(Jaap.all.order(created_at: :desc)))
  end

  def new
    @jaap = authorize Jaap.new
    set_user_context
  end

  def create
    @jaap = authorize Jaap.new(jaap_params)
    if @jaap.save
      redirect_to @jaap, notice: "JAAP saved!"
    else
      set_user_context
      render :new
    end
  end

  def edit
    authorize @jaap
    set_user_context
  end

  def update
    authorize @jaap
    if @jaap.update(jaap_params)
      redirect_to @jaap, notice: "JAAP updated!"
    else
      set_user_context
      render :edit
    end
  end

  def show
    authorize @jaap

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "jaaps_#{@jaap.commune&.full_name_km || 'unknown_commune'}",
               template: "jaaps/pdf/show",
               layout: "pdf",
               formats: [:html]
      end
    end
  end

  def destroy
    @jaap.destroy
    redirect_to jaaps_path, notice: "JAAP deleted!"
  end

  private
    def set_jaap
      @jaap = authorize Jaap.find(params[:id])
    end

    def set_user_context
      @user_role = current_user.role
      @target_province_ids = if current_user.lngo? && current_user.local_ngo&.target_province_ids.present?
        current_user.local_ngo.target_province_ids.to_s.split(",")
      else
        []
      end
    end

    def jaap_params
      params.require(:jaap).permit(:province_id, :district_id, :commune_id, :data, :reference, :reference_cache, :remove_reference).merge(program_id: current_user.program_id)
    end
end
