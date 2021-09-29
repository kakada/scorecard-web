# frozen_string_literal: true

class AddGfUserIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gf_user_id, :integer
  end
end
