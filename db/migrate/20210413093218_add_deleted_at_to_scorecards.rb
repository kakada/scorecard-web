# frozen_string_literal: true

class AddDeletedAtToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :deleted_at, :datetime
    add_index :scorecards, :deleted_at
  end
end
