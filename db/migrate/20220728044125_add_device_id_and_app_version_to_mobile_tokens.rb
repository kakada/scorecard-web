class AddDeviceIdAndAppVersionToMobileTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :mobile_tokens, :device_id, :string
    add_column :mobile_tokens, :device_type, :integer
    add_column :mobile_tokens, :app_version, :string
  end
end
