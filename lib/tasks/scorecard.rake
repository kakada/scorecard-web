# frozen_string_literal: true

namespace :scorecard do
  desc "migrate milestone"
  task migrate_milestone: :environment do
    Scorecard.find_each do |scorecard|
      scorecard.update_column(:progress, scorecard.milestone)
    end
  end

  desc "migrate progress in_review to completed"
  task migrate_to_include_submitted_and_completed_info: :environment do
    Scorecard.where.not(locked_at: nil).find_each do |scorecard|
      scorecard.update_columns(
        progress: "completed",
        submitted_at: scorecard.locked_at,
        completed_at: scorecard.locked_at
      )
    end
  end

  desc "migrate device_type"
  task migrate_device_type: :environment do
    submitted_scorecards = Scorecard.where.not(submitted_at: nil).where(device_type: nil)
    submitted_scorecards.update_all(device_type: "tablet")
  end
end
