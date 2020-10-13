class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators do |t|
      t.integer :categorizable_id
      t.string  :categorizable_type
      t.string  :tag

      t.timestamps
    end
  end
end
