# frozen_string_literal: true

class CreateJaaps < ActiveRecord::Migration[7.0]
  def change
    create_table :jaaps do |t|
      t.string :province_id
      t.string :district_id
      t.string :commune_id
      t.jsonb :data, default: { columns: [], rows: [] }
      t.timestamps
    end

    add_index :jaaps, :data, using: :gin
  end
end
