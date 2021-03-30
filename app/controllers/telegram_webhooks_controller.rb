# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def message(message)
    return migrate_chat_group(message) if message["migrate_to_chat_id"].present?
    return unless managing_member?(message)

    upsert_chat_group(message)
  end

  private
    def migrate_chat_group(message)
      group = ChatGroup.find_by(chat_id: message["chat"]["id"].to_s)
      return if group.nil?

      group.update(chat_id: message["migrate_to_chat_id"], chat_type: ChatGroup::TELEGRAM_SUPER_GROUP)
    end

    def managing_member?(message)
      @member = message["left_chat_member"] || message["new_chat_member"]
      @member.present? && @member["is_bot"] && ChatGroup::TELEGRAM_CHAT_TYPES.include?(message["chat"]["type"])
    end

    def upsert_chat_group(message)
      program = TelegramBot.where("token LIKE ?", "#{@member["id"]}%").first.try(:program)
      return if program.nil?

      group = program.chat_groups.find_or_initialize_by(chat_id: message["chat"]["id"].to_s, provider: "Telegram")
      group.update(
        title: message["chat"]["title"],
        actived: message["new_chat_member"].present?,
        chat_type: message["chat"]["type"]
      )
    end
end
