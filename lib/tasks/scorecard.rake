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

  desc "migrate missing local NGO caused by removed"
  task migrate_missing_local_ngo: :environment do
    scorecards = Scorecard.where.not(local_ngo_id: LocalNgo.pluck(:id))
    scorecards.update_all(local_ngo_id: -1)
  end

  # params scorecard_uuids uses space separated
  # rake scorecard:migrate_wrong_progress_for_scorcard_in_review['222222 111111']
  desc "migrate wrong progress status for scorecard in_review"
  task :migrate_wrong_progress_for_scorcard_in_review, [:scorecard_uuids] => :environment do |task, args|
    uuids = args[:scorecard_uuids].to_s.split(" ") || []

    Scorecard.where(uuid: uuids).each do |scorecard|
      scorecard.update_column(:progress, "in_review") if scorecard.submitted_at.present? && scorecard.completed_at.blank?
    end
  end

  desc "migrate to have dataset_id from primary school code"
  task migrate_to_have_dataset: :environment do
    Scorecard.where.not(primary_school_code: nil).each do |scorecard|
      dataset = Dataset.find_by code: scorecard.primary_school.code

      scorecard.update_column(:dataset_id, dataset.id)
    end
  end
end
