# frozen_string_literal: true

class CreateImportingCafs < ActiveRecord::Migration[6.1]
  def change
    create_table :importing_cafs, id: :uuid do |t|
      t.integer :caf_id
      t.uuid :caf_batch_id

      t.timestamps
    end
  end
end
