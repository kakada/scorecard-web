# frozen_string_literal: true

class CreateRatingScales < ActiveRecord::Migration[6.0]
  def change
    create_table :rating_scales do |t|
      t.string  :code
      t.string  :value
      t.string  :name
      t.integer :program_id

      t.timestamps
    end
  end
end
