# frozen_string_literal: true

class AddMilestoneToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :milestone, :string
  end
end
