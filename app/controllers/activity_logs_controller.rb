class ActivityLogsController < ApplicationController
  def index
    @pagy, @activity_logs = pagy(ActivityLog.filter(activity_log_params).order(created_at: :desc))
  end

  private

  def activity_log_params
    params.permit(:http_format, :http_method, :start_date, :end_date)
  end
end
