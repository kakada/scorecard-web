# frozen_string_literal: true

class CreateCafBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :caf_batches, id: :uuid do |t|
      t.string  :code
      t.integer :total_count, default: 0
      t.integer :valid_count, default: 0
      t.integer :new_count, default: 0
      t.integer :province_count, default: 0
      t.integer :user_id
      t.string  :reference

      t.timestamps
    end
  end
end
