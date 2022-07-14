# frozen_string_literal: true

class CreateScorecardBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :scorecard_batches, id: :uuid do |t|
      t.string  :code
      t.integer :total_item, default: 0
      t.integer :total_valid, default: 0
      t.integer :total_province, default: 0
      t.integer :total_district, default: 0
      t.integer :total_commune, default: 0
      t.integer :user_id
      t.integer :program_id

      t.timestamps
    end
  end
end
