class AddRemoteIpToActivityLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_logs, :remote_ip, :string
  end
end
