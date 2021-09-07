class ActivityLog < ApplicationRecord
  def self.filter(params = {})
    scope = all
    scope = scope.where(http_format: params[:http_format]) if params[:http_format].present?
    scope = scope.where(http_method: params[:http_method]) if params[:http_method].present?
    scope = scope.where("DATE(created_at) >= ?", params[:start_date]) if params[:start_date].present?
    scope = scope.where("DATE(created_at) <= ?", params[:end_date])   if params[:end_date].present?
    scope
  end
end
