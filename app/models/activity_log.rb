class ActivityLog < ApplicationRecord
  extend ActivityLog::RoledScope

  belongs_to :user
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid, optional: true

  default_scope { order(created_at: :desc) }
  delegate :role, to: :user, prefix: true
  delegate :name, to: :program, prefix: true, allow_nil: true

  def self.filter(params = {})
    scope = send(params[:role], params.slice(:user_id, :program_id))
    scope = scope.where(http_format: params[:http_format])            if params[:http_format].present?
    scope = scope.where(http_method: params[:http_method])            if params[:http_method].present?
    scope = scope.where("DATE(created_at) >= ?", params[:start_date]) if params[:start_date].present?
    scope = scope.where("DATE(created_at) <= ?", params[:end_date])   if params[:end_date].present?
    scope
  end
end
