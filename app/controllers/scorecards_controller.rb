# frozen_string_literal: true

class ScorecardsController < ApplicationController
  before_action :set_scorecard, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @scorecards = pagy(policy_scope(Scorecard.filter(filter_params).order(sort_column + " " + sort_direction).includes(:facility, :local_ngo)))
  end

  def show
    authorize @scorecard

    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: ::ScorecardJsonBuilder.new(@scorecard).build
      end

      format.pdf do
        render pdf: "scorecard_#{@scorecard.uuid}",
               inline: PdfTemplateInterpreter.new(@scorecard.uuid).interpreted_message
      end
    end
  end

  def new
    @scorecard = authorize Scorecard.new
  end

  def create
    @scorecard = authorize current_program.scorecards.new(scorecard_params)

    if @scorecard.save
      flash[:notice] = t("scorecard.create_successfully")
      redirect_to scorecard_url(@scorecard.uuid)
    else
      render :new
    end
  end

  def edit
    authorize @scorecard
  end

  def update
    authorize @scorecard

    if @scorecard.update_attributes(scorecard_params)
      redirect_to scorecards_url
    else
      render :edit
    end
  end

  def destroy
    authorize @scorecard
    @scorecard.destroy

    redirect_to scorecards_url
  end

  private
    def set_scorecard
      @scorecard = Scorecard.find_by uuid: params[:id]
    end

    def scorecard_params
      params.require(:scorecard).permit(:unit_type_id, :facility_id, :description,
        :province_id, :district_id, :commune_id, :year, :primary_school_code,
        :planned_start_date, :planned_end_date, :local_ngo_id, :scorecard_type
      ).merge({ creator_id: current_user.id })
    end

    def filter_params
      params.permit(
        :start_date, :facility_id, :uuid, :filter,
        :year, :province_id, :local_ngo_id
      ).merge(
        program_id: current_user.program_id,
        program_uuid: current_user.program_uuid
      )
    end
end
