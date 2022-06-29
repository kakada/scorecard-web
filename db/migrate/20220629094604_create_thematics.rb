class CreateThematics < ActiveRecord::Migration[6.1]
  def change
    create_table :thematics, id: :uuid do |t|
      t.string :code
      t.string :name
      t.text   :description

      t.timestamps
    end
  end
end
