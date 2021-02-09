class CreatePrimarySchools < ActiveRecord::Migration[6.0]
  def change
    create_table :primary_schools do |t|
      t.string :code
      t.string :name_en
      t.string :name_km
      t.string :commune_id

      t.timestamps
    end
  end
end
