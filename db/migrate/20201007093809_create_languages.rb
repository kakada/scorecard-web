# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string  :code
      t.string  :name
      t.string  :json_file
      t.integer :program_id

      t.timestamps
    end
  end
end
