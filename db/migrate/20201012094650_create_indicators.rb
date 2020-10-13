class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators do |t|
      t.integer :sector_id
      t.integer :category_id
      t.string  :tag
      t.integer :program_id

      t.timestamps
    end
  end
end
