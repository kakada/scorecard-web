class AddLanguageCodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :language_code, :string, default: 'en'
  end
end
