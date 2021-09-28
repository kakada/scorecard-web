# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups
#
#  id         :bigint           not null, primary key
#  title      :string
#  chat_id    :string
#  actived    :boolean          default(TRUE)
#  reason     :text
#  provider   :string
#  program_id :integer
#  chat_type  :string           default("group")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ChatGroup < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :chat_groups_notifications
  has_many :notifications, through: :chat_groups_notifications

  scope :telegrams, -> { where(provider: "Telegram") }
  scope :actives, -> { where(actived: true) }

  TELEGRAM_CHAT_TYPES = %w[group supergroup]
  TELEGRAM_SUPER_GROUP = "supergroup"
  TELEGRAM_GROUP = "group"
end
