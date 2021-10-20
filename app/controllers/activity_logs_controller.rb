# frozen_string_literal: true

class ActivityLogsController < ApplicationController
  before_action :set_duration

  def index
    authorize ActivityLog
    @pagy, @activity_logs = pagy(ActivityLog.filter(filter_params).includes(:user, :program))
  end

  private
    def filter_params
      activity_log_params.merge(current_user_params)
    end

    def activity_log_params
      params.permit(:http_format, :http_method, :start_date, :end_date)
    end

    def current_user_params
      { role: current_user.role, user_id: current_user.id, program_id: current_user.program_id }
    end

    def set_duration
      @duration = duration? ? duration : I18n.t("shared.all")
    end

    def duration?
      params[:start_date].present? || params[:end_date].present?
    end

    def duration
      "#{params[:start_date]} - #{params[:end_date]}"
    end
end
