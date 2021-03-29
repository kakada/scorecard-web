# frozen_string_literal: true

module Notifications
  class Email < ::Notification
    def notify_async
      return unless program.enable_email_notification?

      NotificationWorker.perform_async(id, self.class.to_s)
    end

    def notify_groups
      NotificationMailer.notify(emails.join(","), message.display_content).deliver_now
    end
  end
end
