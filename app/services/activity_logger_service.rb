# frozen_string_literal: true

class ActivityLoggerService
  def self.log(logger)
    return unless loggable?(logger[:path])

    ActivityLogsWorker.perform_async(logger)
  end

  private

  def self.loggable?(path)
    ActivityLog.whitelist_controllers.any? do |controller_name|
      path.downcase.include?(controller_name)
    end
  end
end
