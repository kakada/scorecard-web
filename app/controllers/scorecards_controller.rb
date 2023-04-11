# frozen_string_literal: true

class ScorecardsController < ApplicationController
  helper_method :filter_params
  before_action :set_scorecard, only: [:show, :edit, :update, :destroy, :complete]

  def index
    respond_to do |format|
      format.html {
        @pagy, @scorecards = pagy(
          policy_scope(Scorecard.filter(filter_params)
            .order(sort_param)
            .includes(
              :facility, :local_ngo, :request_changes, :primary_school, :scorecard_progresses, program: :program_scorecard_types
            )
          )
        )
      }

      format.xlsx {
        @scorecards = policy_scope(authorize Scorecard.filter(filter_params).order(sort_param))

        if @scorecards.length > Settings.max_download_scorecard_record
          flash[:alert] = t("scorecard.file_size_is_too_big", max_record: Settings.max_download_scorecard_record)
          redirect_to scorecards_url
        else
          render xlsx: download_template_name, filename: "scorecards_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
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

    if @scorecard.update(scorecard_params)
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

  def complete
    authorize @scorecard, :in_review?
    @scorecard.completed_by(current_user)

    redirect_to scorecard_url(@scorecard.uuid)
  end

  private
    def set_scorecard
      @scorecard = Scorecard.find_by uuid: params[:uuid]
    end

    def scorecard_params
      params.require(:scorecard).permit(:unit_type_id, :facility_id, :description,
        :province_id, :district_id, :commune_id, :year, :primary_school_code,
        :planned_start_date, :planned_end_date, :local_ngo_id, :scorecard_type,
        :dataset_id
      ).merge({ creator_id: current_user.id })
    end

    def filter_params
      params.permit(
        :start_date, :end_date, :uuid, :filter, :scorecard_type, :batch_code,
        years: [], province_ids: [], local_ngo_ids: [], facility_ids: []
      ).merge(program_id: current_user.program_id)
    end

    def download_template_name
      mode = params["mode"] == "full" ? "full" : "short"

      "download_in_#{mode}"
    end
end
