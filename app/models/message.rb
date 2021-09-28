# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  milestone  :string
#  program_id :integer
#  actived    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Message < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :notifications
  has_one :telegram_notification, class_name: "Notifications::Telegram", dependent: :destroy
  has_one :email_notification, class_name: "Notifications::Email", dependent: :destroy

  # Nested attribute
  accepts_nested_attributes_for :email_notification, allow_destroy: true
  accepts_nested_attributes_for :telegram_notification, allow_destroy: true

  validates :content, presence: true
  validates :milestone, presence: true
  validates :milestone, inclusion: { in: ScorecardProgress.statuses.keys }

  def display_content(scorecard_id)
    MessageInterpreter.new(scorecard_id, content).interpreted_message
  end
end
