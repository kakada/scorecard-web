# frozen_string_literal: true

class AddRunnerIdToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :runner_id, :integer
  end
end
