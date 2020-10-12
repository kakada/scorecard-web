class CreateScorecardsCafs < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecards_cafs do |t|
      t.integer :caf_id
      t.integer :scorecard_id

      t.timestamps
    end
  end
end
