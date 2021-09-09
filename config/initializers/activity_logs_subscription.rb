ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, started, finished, unique_id, data|
  args = data.slice(:controller, :action, :format, :method, :path, :status, :current_user_id)
  args[:payload] = data[:params].except(:action, :controller)

  if log_whitelist?(args[:controller])
    ActivityLogsWorker.perform_async(args)
  end
end

def log_whitelist?(controller_name)
  log_controllers.any? do |item| 
    controller_name.downcase.include?(item)
  end
end

def log_controllers
  controllers = ENV['ACTIVITY_LOGS_CONTROLLERS'].to_s
  controllers.split(",")
end
