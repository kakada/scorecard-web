# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations, id: :uuid do |t|
      t.string :key, null: false
      t.string :locale, null: false
      t.string :label, null: false

      t.timestamps
    end

    add_index :translations, [:key, :locale], unique: true
  end
end
