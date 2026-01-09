# frozen_string_literal: true

class AddTokenToScorecards < ActiveRecord::Migration[6.1]
  def up
    add_column :scorecards, :token, :string, limit: 64
    add_index :scorecards, :token, unique: true
  end

  def down
    remove_index :scorecards, :token
    remove_column :scorecards, :token
  end
end
