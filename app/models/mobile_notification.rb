# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_notifications
#
#  id            :bigint           not null, primary key
#  title         :string
#  body          :text
#  success_count :integer
#  failure_count :integer
#  creator_id    :integer
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class MobileNotification < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid, optional: true
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"

  validates :body, presence: true

  after_commit :push_notification_async, on: [:create]

  def push_notification_async
    MobileNotificationWorker.perform_async(id)
  end

  def build_content
    { notification: { title: title, body: body } }
  end
end
