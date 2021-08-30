# frozen_string_literal: true

class AddEducationalBackgroundIdAndScorecardKnowledgeIdToCafs < ActiveRecord::Migration[6.0]
  def change
    add_column :cafs, :educational_background_id, :string
    add_column :cafs, :scorecard_knowledge_id, :string
  end
end
