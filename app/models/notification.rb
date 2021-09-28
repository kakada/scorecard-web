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
class Notification < ApplicationRecord
  self.inheritance_column = :provider

  PROVIDERS = %w(Notifications::Telegram Notifications::Email).freeze

  belongs_to :message
  has_many :chat_groups_notifications
  has_many :chat_groups, through: :chat_groups_notifications

  validates :provider, presence: true, inclusion: { in: PROVIDERS }

  accepts_nested_attributes_for :chat_groups_notifications, allow_destroy: true

  scope :telegrams, -> { where(provider: "Notifications::Telegram") }
  scope :emails, -> { where(provider: "Notifications::Email") }

  def notify_groups
    raise "Abstract Method"
  end

  def program
    message.program
  end

  # Class Methods
  def self.providers
    PROVIDERS
  end
end
