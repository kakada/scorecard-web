# frozen_string_literal: true

class JaapsController < ApplicationController
  before_action :set_jaap, only: [:show, :edit, :update, :destroy, :complete]

  def index
    @pagy, @jaaps = pagy(
      policy_scope(Jaap.includes(:program, :user, :scorecard)
        .order(created_at: :desc))
    )
  end

  def show
    authorize @jaap

    respond_to do |format|
      format.html
      format.json { render json: jaap_json }
    end
  end

  def new
    @jaap = authorize Jaap.new(
      program: current_program,
      user: current_user,
      field_definitions: Jaap.default_field_definitions
    )
  end

  def create
    @jaap = authorize current_program.jaaps.new(jaap_params.merge(user: current_user))

    if @jaap.save
      flash[:notice] = t('jaap.create_successfully')
      redirect_to jaap_path(@jaap.uuid)
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
      flash[:notice] = t('jaap.update_successfully')
      redirect_to jaap_path(@jaap.uuid)
    else
      render :edit
    end
  end

  def destroy
    authorize @jaap
    @jaap.destroy

    flash[:notice] = t('jaap.delete_successfully')
    redirect_to jaaps_path
  end

  def complete
    authorize @jaap
    @jaap.complete!

    flash[:notice] = t('jaap.complete_successfully')
    redirect_to jaap_path(@jaap.uuid)
  end

  private

  def set_jaap
    @jaap = Jaap.find_by!(uuid: params[:uuid])
  end

  def jaap_params
    params.require(:jaap).permit(
      :title,
      :description,
      :scorecard_id,
      field_definitions: [],
      rows_data: []
    )
  end

  def jaap_json
    {
      uuid: @jaap.uuid,
      title: @jaap.title,
      description: @jaap.description,
      field_definitions: @jaap.field_definitions,
      rows_data: @jaap.rows_data,
      completed_at: @jaap.completed_at,
      created_at: @jaap.created_at,
      updated_at: @jaap.updated_at,
      user: {
        id: @jaap.user.id,
        name: @jaap.user.name
      }
    }
  end
end
