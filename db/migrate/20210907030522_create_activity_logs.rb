# frozen_string_literal: true

class CreateActivityLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_logs do |t|
      t.string :controller_name
      t.string :action_name
      t.string :http_format, index: true
      t.string :http_method, index: true
      t.string :path
      t.integer :http_status
      t.belongs_to :user
      t.belongs_to :program
      t.json :payload, default: {}

      t.timestamps
    end
  end
end
