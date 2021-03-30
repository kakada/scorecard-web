# frozen_string_literal: true

module Notifications
  class Email < ::Notification
    def notify_async(scorecard_id)
      return unless program.enable_email_notification?

      NotificationWorker.perform_async(id, scorecard_id)
    end

    def notify_groups(display_message)
      NotificationMailer.notify(emails.join(","), display_message).deliver_now
    end
  end
end
