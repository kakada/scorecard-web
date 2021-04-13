# frozen_string_literal: true

class AddRunningDateToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :running_date, :datetime
  end
end
