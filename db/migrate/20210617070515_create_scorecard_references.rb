# frozen_string_literal: true

class CreateScorecardReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecard_references do |t|
      t.string :uuid
      t.string :scorecard_uuid
      t.string :attachment
      t.string :kind

      t.timestamps
    end
  end
end
