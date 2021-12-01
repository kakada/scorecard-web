# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify(emails, body_message)
    @body_message = body_message
    mail(to: emails, subject: "Scorecard Notification")
  end

  def notify_request_change(emails, option)
    @body_message = option[:body_message]
    @scorecard = option[:scorecard]
    @request_change = option[:request_change]

    mail(to: emails, subject: "Scorecard RequestChange Notification")
  end
end
