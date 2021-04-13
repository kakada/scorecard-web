# frozen_string_literal: true

class RenameScorecardFinishedDateOnAppToFinishedDate < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :finished_date, :datetime
    remove_column :scorecards, :finished_date_on_app
  end
end
