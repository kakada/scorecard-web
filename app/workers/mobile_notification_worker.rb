# frozen_string_literal: true

class MobileNotificationWorker
  include Sidekiq::Worker

  def perform(notification_id)
    @notification = MobileNotification.find_by(id: notification_id)

    return unless @notification.present?

    fcm = FCM.new(ENV["FIREBASE_SERVER_KEY"])

    Pundit.policy_scope(@notification.creator, MobileToken).in_batches do |relation|
      response = fcm.send(relation.pluck(:token), @notification.build_content)
      res_body = JSON.parse(response[:body])

      @notification.update(success_count: res_body["success"].to_i, failure_count: res_body["failure"].to_i)
    end
  end
end
