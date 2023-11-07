# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveSupport::Notifications.subscribe(/process_action.action_controller|#{ActivityLog.signout_activity}/) do |name, started, finished, unique_id, data|
    request_log = RequestLogParser.parse(data).as_json
    ActivityLogsWorker.perform_async(request_log)
  end
end
