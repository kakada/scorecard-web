# frozen_string_literal: true

class CreateIndicatorActivityCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :indicator_activity_categories, id: :uuid do |t|
      t.string :name_en
      t.string :name_km
      t.text :description_en
      t.text :description_km
      t.integer :display_order, default: 0
      t.integer :program_id, null: false
      t.foreign_key :programs, column: :program_id

      t.timestamps
    end

    add_reference :indicator_activities, :indicator_activity_category, type: :uuid, foreign_key: true
  end
end
