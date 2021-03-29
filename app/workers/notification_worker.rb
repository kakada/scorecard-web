# frozen_string_literal: true

class NotificationWorker
  include Sidekiq::Worker

  def perform(id, klass_name)
    notification = klass_name.constantize.find_by(id: id)

    return if notification.nil?

    notification.notify_groups
  end
end
