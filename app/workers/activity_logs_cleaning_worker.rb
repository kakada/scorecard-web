# frozen_string_literal: true

require "sidekiq-scheduler"

class ActivityLogsCleaningWorker
  include Sidekiq::Worker

  def perform
    ActivityLog.where("created_at < ?", Time.zone.now.prev_year.beginning_of_day).in_batches do |relation|
      relation.destroy_all
    end
  end
end
