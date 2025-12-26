# frozen_string_literal: true

class CreateJaaps < ActiveRecord::Migration[7.0]
  def change
    create_table :jaaps do |t|
      t.string :title
      t.text :description
      t.string :uuid, null: false
      t.references :program, foreign_key: true
      t.references :scorecard, type: :string, foreign_key: { to_table: :scorecards, primary_key: :uuid }
      t.references :user, foreign_key: true
      t.jsonb :field_definitions, default: []
      t.jsonb :rows_data, default: []
      t.datetime :completed_at
      t.timestamps

      t.index :uuid, unique: true
    end
  end
end
