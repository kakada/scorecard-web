# frozen_string_literal: true

module Notifications
  class Telegram < ::Notification
    def notify_async
      return unless program.telegram_bot_enabled

      NotificationWorker.perform_async(id, self.class.to_s)
    end

    def notify_groups
      chat_groups.actives.each do |group|
        bot.send_message(chat_id: group.chat_id, text: message.display_content, parse_mode: :HTML)
      rescue ::Telegram::Bot::Forbidden => e
        group.update_attributes(actived: false, reason: e)
      end
    end

    def bot
      @bot ||= ::Telegram::Bot::Client.new(program.telegram_bot.token, program.telegram_bot.username)
    end
  end
end
