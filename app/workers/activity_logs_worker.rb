# frozen_string_literal: true

class ActivityLogsWorker
  include Sidekiq::Worker

  def perform(args = {})
    current_user = User.find(args["current_user_id"])

    ActivityLog.create do |log|
      log.controller_name = args["controller"]
      log.action_name     = args["action"]
      log.http_format     = args["format"]
      log.http_method     = args["method"]
      log.path            = args["path"]
      log.http_status     = args["status"]
      log.payload         = args["payload"]
      log.remote_ip       = args["remote_ip"]
      log.user            = current_user
      log.program         = current_user&.program
    end
  end
end
