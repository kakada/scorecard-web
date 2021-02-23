class AddIndexToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_index :scorecards, :uuid
  end
end
