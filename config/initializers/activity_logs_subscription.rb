# frozen_string_literal: true

ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, started, finished, unique_id, data|
  request_log = RequestLogParser.parse(data)

  ActivityLoggerService.log(request_log)
end
