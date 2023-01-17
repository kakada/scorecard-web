# frozen_string_literal: true

class AddRemovingScorecardBatchIdToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :removing_scorecard_batch_id, :uuid
  end
end
