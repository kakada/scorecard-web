# frozen_string_literal: true

class MobileNotificationWorker
  include Sidekiq::Worker

  def perform(notification_id)
    @notification = MobileNotification.find_by(id: notification_id)
    filter_params = { app_versions: @notification.app_versions }

    Pundit.policy_scope(@notification.creator, MobileToken.filter(filter_params)).in_batches do |relation|
      response = PushNotificationService.notify(relation.pluck(:token), @notification.build_content)
      res_body = JSON.parse(response[:body])

      @notification.update(success_count: res_body["success"].to_i, failure_count: res_body["failure"].to_i)
    end
  end
end
