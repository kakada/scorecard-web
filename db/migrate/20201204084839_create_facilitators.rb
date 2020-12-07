class CreateFacilitators < ActiveRecord::Migration[6.0]
  def change
    create_table :facilitators do |t|
      t.integer :caf_id
      t.integer :scorecard_uuid
      t.string  :position

      t.timestamps
    end
  end
end
