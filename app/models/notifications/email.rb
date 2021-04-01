# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  provider   :string
#  emails     :text             default([]), is an Array
#  message_id :integer
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Notifications
  class Email < ::Notification
    def notify_async(scorecard_id)
      return unless program.enable_email_notification? && message.actived

      NotificationWorker.perform_async(id, scorecard_id)
    end

    def notify_groups(display_message)
      NotificationMailer.notify(emails.join(","), display_message).deliver_now
    end
  end
end
