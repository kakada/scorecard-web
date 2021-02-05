class AddCreatorIdToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :creator_id, :integer
  end
end
