# frozen_string_literal: true

class CreateJaaps < ActiveRecord::Migration[7.0]
  def change
    create_table :jaaps, id: :uuid do |t|
      t.string :province_id
      t.string :district_id
      t.string :commune_id
      t.string :reference
      t.jsonb :data, default: {}
      t.integer :program_id, null: false
      t.timestamps
    end

    add_index :jaaps, :data, using: :gin
    add_index :jaaps, :program_id
  end
end
