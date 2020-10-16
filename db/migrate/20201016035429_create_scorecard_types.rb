# frozen_string_literal: true

class CreateScorecardTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecard_types do |t|
      t.string  :name
      t.integer :program_id

      t.timestamps
    end
  end
end
