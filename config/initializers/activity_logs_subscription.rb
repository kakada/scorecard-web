ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, started, finished, unique_id, data|
  args = data.slice(:controller, :action, :format, :method, :path, :status, :current_user_id)
  args[:payload] = data[:params].except(:action, :controller)

  ActivityLogsEventHandler.new(args).process
end
