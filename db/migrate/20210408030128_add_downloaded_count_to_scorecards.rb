# frozen_string_literal: true

class AddDownloadedCountToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :downloaded_count, :integer, default: 0
    add_column :scorecards, :progress, :integer
    Rake::Task["scorecard:migrate_milestone"].invoke
    remove_column :scorecards, :milestone
  end
end
