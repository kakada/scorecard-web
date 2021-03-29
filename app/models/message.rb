# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :program
  has_many :notifications
  has_one :telegram_notification, class_name: 'Notifications::Telegram', dependent: :destroy
  has_one :email_notification, class_name: 'Notifications::Email', dependent: :destroy

  # Nested attribute
  accepts_nested_attributes_for :email_notification, allow_destroy: true
  accepts_nested_attributes_for :telegram_notification, allow_destroy: true

  validates :content, presence: true
  validates :milestone, presence: true
  validates :milestone, inclusion: { in: Scorecard::MILESTONES }

  def display_content
    # interpret the content
    content
  end
end
