class CreateCafs < ActiveRecord::Migration[6.0]
  def change
    create_table :cafs do |t|
      t.string   :name
      t.string   :sex
      t.string   :date_of_birth
      t.string   :tel
      t.string   :address
      t.integer  :local_ngo_id

      t.timestamps
    end
  end
end
