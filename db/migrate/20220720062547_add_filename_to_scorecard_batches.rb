class AddFilenameToScorecardBatches < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecard_batches, :filename, :string
  end
end
