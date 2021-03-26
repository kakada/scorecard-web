# frozen_string_literal: true

class AddEnableEmailNotificationToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :enable_email_notification, :boolean, default: false
  end
end
