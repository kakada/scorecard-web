# frozen_string_literal: true

class CreateChatGroupsNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_groups_notifications do |t|
      t.integer  :chat_group_id
      t.integer  :notification_id

      t.timestamps
    end
  end
end
