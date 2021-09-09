class ActivityLogsEventHandler
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def process
    return unless loggable?(args[:controller])

    ActivityLogsWorker.perform_async(args)
  end

  private

  def loggable?(current_controller)
    whitelist_controllers.any? do |controller| 
      current_controller.downcase.include?(controller)
    end
  end
  
  def whitelist_controllers
    ENV['ACTIVITY_LOGS_CONTROLLERS'].to_s.split(",")
  end
end
