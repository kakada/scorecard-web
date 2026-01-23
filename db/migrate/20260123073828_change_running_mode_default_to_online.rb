# frozen_string_literal: true

class ChangeRunningModeDefaultToOnline < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:scorecards, :running_mode, from: 0, to: 1)
  end
end
