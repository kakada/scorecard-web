class AddDeviceIdAndSubmitterIdToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :device_id, :string
    add_column :scorecards, :submitter_id, :integer
  end
end
