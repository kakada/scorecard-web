class ActivityLogsWorker
  include Sidekiq::Worker

  def perform(args)
    ActivityLog.create do |log|
      log.controller_name = args["controller"]
      log.action_name     = args["action"]
      log.http_format     = args["format"]
      log.http_method     = args["method"]
      log.path            = args["path"]
      log.http_status     = args["status"]
      log.payload         = args["payload"]
    end
  end
end
