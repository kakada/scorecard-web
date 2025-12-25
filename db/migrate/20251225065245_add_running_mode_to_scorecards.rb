# frozen_string_literal: true

class AddRunningModeToScorecards < ActiveRecord::Migration[7.0]
  def change
    add_column :scorecards, :running_mode, :integer, default: 0
  end
end
