class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators do |t|
      t.integer :category_id
      t.string  :tag

      t.timestamps
    end
  end
end
