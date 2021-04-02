# frozen_string_literal: true

class CreateChatGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_groups do |t|
      t.string   :title
      t.string   :chat_id
      t.boolean  :actived, default: true
      t.text     :reason
      t.string   :provider
      t.integer  :program_id
      t.string   :chat_type, default: "group"

      t.timestamps
    end
  end
end
