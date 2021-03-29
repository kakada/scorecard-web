# frozen_string_literal: true

module Scorecards::CallbackNotification
  extend ActiveSupport::Concern

  included do
    after_update :send_notification, if: :saved_change_to_milestone?

    private
      def send_notification
        message = program.messages.find_by milestone: milestone
        return if message.nil?

        message.notifications.each do |notification|
          notification.provider.constantize.find(notification.id).notify_async
        end
      end
  end
end
