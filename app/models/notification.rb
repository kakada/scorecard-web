# frozen_string_literal: true

class Notification < ApplicationRecord
  self.inheritance_column = :provider

  belongs_to :message
  has_many :chat_groups_notifications
  has_many :chat_groups, through: :chat_groups_notifications

  serialize :emails, Array

  accepts_nested_attributes_for :chat_groups_notifications, allow_destroy: true

  scope :telegrams, -> { where(provider: "Telegram") }
  scope :emails, -> { where(provider: "Email") }

  def notify_groups
    raise "Abstract Method"
  end

  # Class Methods
  def self.providers
    %w[Telegram Email]
  end
end
