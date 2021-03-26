# frozen_string_literal: true

module Notifications
  class Email < ::Notification
    def notify_groups
      # NotificationMailer.notify(emails.join(","), message.display_content).deliver_now
    end
  end
end
