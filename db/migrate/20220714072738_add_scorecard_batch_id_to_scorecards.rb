# frozen_string_literal: true

class AddScorecardBatchIdToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :scorecard_batch_code, :string
  end
end
