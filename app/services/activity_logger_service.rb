# frozen_string_literal: true

class ActivityLoggerService
  def self.log(logger)
    return unless loggable?(logger[:controller])

    ActivityLogsWorker.perform_async(logger)
  end

  private
    def self.loggable?(current_controller)
      whitelist_controllers.any? do |controller|
        current_controller.downcase.include?(controller)
      end
    end

    def self.whitelist_controllers
      ENV["ACTIVITY_LOGS_CONTROLLERS"].to_s.split(",")
    end
end
