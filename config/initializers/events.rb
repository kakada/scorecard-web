ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, started, finished, unique_id, data|
  #Rails.logger.info "#{name} Received! (started: #{started}, finished: #{finished}, data: #{data[:controller]})"
  #puts "*" * 100
  # send to job
  # job write to database
  args = data.slice(:controller, :action, :format, :method, :path, :status)
  args[:payload] = data[:params].except(:action, :controller)
  ActivityLogsWorker.perform_async args
end
