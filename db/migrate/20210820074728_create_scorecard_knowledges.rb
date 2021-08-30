# frozen_string_literal: true

class CreateScorecardKnowledges < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecard_knowledges, id: :uuid do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
