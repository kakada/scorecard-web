class AddThematicIdToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :thematic_id, :uuid
  end
end
