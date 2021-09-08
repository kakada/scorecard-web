class ActivityLogsController < ApplicationController
  before_action :set_duration

  def index
    @pagy, @activity_logs = pagy(ActivityLog.filter(activity_log_params).order(created_at: :desc))
  end

  private

  def activity_log_params
    params.permit(:http_format, :http_method, :start_date, :end_date)
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
