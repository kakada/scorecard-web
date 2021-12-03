# frozen_string_literal: true

class AddCompletedAtToScorecards < ActiveRecord::Migration[6.1]
  def up
    add_column :scorecards, :submitted_at, :datetime
    add_column :scorecards, :completed_at, :datetime

    # Copy locked_at to submitted_at and progress to completed
    Rake::Task["scorecard:migrate_to_include_submitted_and_completed_info"].invoke

    # Move message with milestone submitted to in_review
    Rake::Task["message:migrate_milestone_submitted_to_in_review"].invoke
  end

  def down
    remove_column :scorecards, :submitted_at
    remove_column :scorecards, :completed_at
  end
end
