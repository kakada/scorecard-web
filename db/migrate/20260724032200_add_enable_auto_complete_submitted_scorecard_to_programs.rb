# frozen_string_literal: true

class AddEnableAutoCompleteSubmittedScorecardToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :enable_auto_complete_submitted_scorecard, :boolean, default: false
    add_column :programs, :auto_complete_submitted_scorecard_in_days, :integer, default: 15, null: false
  end
end
