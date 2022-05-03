# frozen_string_literal: true

class CreateCafsScorecardKnowledges < ActiveRecord::Migration[6.1]
  def change
    create_table :cafs_scorecard_knowledges do |t|
      t.integer :caf_id
      t.uuid    :scorecard_knowledge_id

      t.timestamps
    end
  end
end
