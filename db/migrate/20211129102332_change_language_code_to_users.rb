# frozen_string_literal: true

class ChangeLanguageCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:users, :language_code, "km")
  end
end
