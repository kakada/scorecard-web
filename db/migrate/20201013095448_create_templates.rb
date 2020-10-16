class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.string  :name
      t.integer :program_id

      t.timestamps
    end
  end
end
