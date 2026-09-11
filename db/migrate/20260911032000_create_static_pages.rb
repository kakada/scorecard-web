# frozen_string_literal: true

class CreateStaticPages < ActiveRecord::Migration[6.0]
  def change
    create_table :static_pages, id: :uuid do |t|
      t.string :slug, null: false
      t.text :content_en
      t.text :content_km

      t.timestamps
    end

    add_index :static_pages, :slug, unique: true
  end
end
