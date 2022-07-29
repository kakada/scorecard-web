# frozen_string_literal: true

class AddAppVersionsToMobileNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :mobile_notifications, :app_versions, :string, array: true, default: []
  end
end
