# frozen_string_literal: true

# == Schema Information
#
# Table name: activity_logs
#
#  id              :bigint           not null, primary key
#  controller_name :string
#  action_name     :string
#  http_format     :string
#  http_method     :string
#  path            :string
#  http_status     :integer
#  user_id         :bigint
#  program_id      :bigint
#  payload         :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ActivityLog < ApplicationRecord
  extend ActivityLog::RoledScope

  belongs_to :user
  belongs_to :program, optional: true

  default_scope { order(created_at: :desc) }
  delegate :role, to: :user, prefix: true
  delegate :name, to: :program, prefix: true, allow_nil: true

  validate :ensure_unique_get_request_within_time_range, on: :create

  def self.filter(params = {})
    scope = send(params[:role], params.slice(:user_id, :program_id))
    scope = scope.where(http_format: params[:http_format])            if params[:http_format].present?
    scope = scope.where(http_method: params[:http_method])            if params[:http_method].present?
    scope = scope.where("path ILIKE ?", "%#{params[:path]}%")         if params[:path].present?
    scope = scope.where("DATE(created_at) >= ?", params[:start_date]) if params[:start_date].present?
    scope = scope.where("DATE(created_at) <= ?", params[:end_date])   if params[:end_date].present?
    scope
  end

  def self.whitelist_controllers
    ENV['ACTIVITY_LOGS_CONTROLLERS'].to_s.split(",")
  end

  private

  def ensure_unique_get_request_within_time_range
    if get? && activity_exists?
      errors.add(:base, I18n.t('activity_logs.request_duplicate'))
      Rails.logger.info "request #{path} from #{remote_ip} by user_id: #{user.id} is already existed"
    end
  end

  def get?
    http_method&.upcase == 'GET'
  end

  def activity_exists?
    self.class\
      .where(path: path, remote_ip: remote_ip, user: user)
      .where('created_at > ?', loggable_period)
      .exists?
  end

  def loggable_period
    ENV['ACTIVITY_LOGGABLE_PERIODIC_IN_MINUTE'].to_i.minutes.ago
  end
end
