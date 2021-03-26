# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string   :provider
      t.text     :emails
      t.integer  :message_id
      t.integer  :program_id

      t.timestamps
    end
  end
end
