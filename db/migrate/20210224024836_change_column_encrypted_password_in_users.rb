class ChangeColumnEncryptedPasswordInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :encrypted_password, :string, default: "", null: true
  end
end
