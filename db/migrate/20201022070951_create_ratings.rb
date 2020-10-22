class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :voting_indicator_id
      t.integer :voting_person_id
      t.string  :scorecard_uuid
      t.integer :score

      t.timestamps
    end
  end
end
