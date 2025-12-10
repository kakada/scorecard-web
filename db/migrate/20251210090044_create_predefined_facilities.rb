# frozen_string_literal: true

class CreatePredefinedFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :predefined_facilities do |t|
      t.string :code, null: false
      t.string :name_en, null: false
      t.string :name_km, null: false
      t.string :parent_code
      t.string :category_code

      t.timestamps
    end

    add_index :predefined_facilities, :code, unique: true
  end
end
