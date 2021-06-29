# frozen_string_literal: true

class CreateMobileNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :mobile_notifications do |t|
      t.string  :title
      t.text    :body
      t.integer :success_count
      t.integer :failure_count
      t.integer :creator_id
      t.integer :program_id

      t.timestamps
    end
  end
end
