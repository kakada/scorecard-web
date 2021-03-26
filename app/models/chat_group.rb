# frozen_string_literal: true

class ChatGroup < ApplicationRecord
  has_many :chat_groups_notifications
  has_many :notifications, through: :chat_groups_notifications

  scope :telegrams, -> { where(provider: "Telegram") }
  scope :actives, -> { where(actived: true) }

  TELEGRAM_CHAT_TYPES = %w[group supergroup]
  TELEGRAM_SUPER_GROUP = "supergroup"
  TELEGRAM_GROUP = "group"
end
