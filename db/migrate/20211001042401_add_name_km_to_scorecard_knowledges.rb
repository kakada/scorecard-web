class AddNameKmToScorecardKnowledges < ActiveRecord::Migration[6.0]
  def change
    rename_column :scorecard_knowledges, :name, :name_en
    add_column :scorecard_knowledges, :name_km, :string
  end
end
