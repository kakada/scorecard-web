# frozen_string_literal: true

module MessagesHelper
  def telegram_icon_status(message)
    return "" unless message.present?

    if message.program.telegram_bot_enabled && message.telegram_notification.chat_groups.telegrams.actives.length > 0
      return "<a class='p-1 pointer text-success' data-trigger='hover' data-content='#{message.telegram_notification.chat_groups.pluck(:title).join('; ')}' data-toggle='popover' title='#{I18n.t('message.notify_to')}'><i class='fab fa-telegram font-size-24 active-telegram-icon'></i></a>"
    end

    title = !message.program.telegram_bot_enabled ? "message.telegram_notification_inactive" : "message.no_chat_group_selected"

    "<a class='p-1 pointer text-secondary position-relative' title='#{I18n.t(title)}' data-toggle='tooltip'><i class='fab fa-telegram font-size-24'></i></a>"
  end

  def email_icon_status(message)
    return "" unless message.present?

    if message.program.enable_email_notification? && message.email_notification.emails.length > 0
      return "<a class='p-1 pointer text-danger' data-trigger='hover' data-content='#{message.email_notification.emails.join('; ')}' data-toggle='popover' title='#{I18n.t('message.notify_to')}'><i class='far fa-envelope font-size-24'></i></a>"
    end

    title = !message.program.enable_email_notification? ? "message.email_notification_inactived" : "message.no_email_selected"

    "<a class='p-1 pointer text-secondary' title='#{I18n.t(title)}' data-toggle='tooltip'><i class='far fa-envelope font-size-24'></i></a>"
  end
end
