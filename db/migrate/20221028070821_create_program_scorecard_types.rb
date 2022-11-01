# frozen_string_literal: true

class CreateProgramScorecardTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :program_scorecard_types, id: :uuid do |t|
      t.integer :code
      t.string  :name_en
      t.string  :name_km
      t.integer :program_id

      t.timestamps
    end
  end
end
