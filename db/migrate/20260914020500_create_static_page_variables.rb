# frozen_string_literal: true

class CreateStaticPageVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :static_page_variables, id: :uuid do |t|
      t.string :key, null: false
      t.integer :variable_type, null: false, default: 0
      t.text :value
      t.string :image
      t.text :description

      t.timestamps
    end

    add_index :static_page_variables, :key, unique: true
  end
end
