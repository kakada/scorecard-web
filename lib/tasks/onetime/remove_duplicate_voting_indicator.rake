# frozen_string_literal: true

namespace :onetime do
  desc "Remove duplicate voting indicators to prepare for unique index addition"
  task remove_duplicate_voting_indicators: :environment do
    duplicates = VotingIndicator
      .select("scorecard_uuid, indicator_uuid, COUNT(*) as total")
      .group(:scorecard_uuid, :indicator_uuid)
      .having("COUNT(*) > 1")

    puts "Found #{duplicates.length} duplicate groups"

    # Note: avoid find_each on grouped relations (Postgres requires ORDER BY on grouped columns)
    duplicates.each do |dup|
      records = VotingIndicator
        .where(
          scorecard_uuid: dup.scorecard_uuid,
          indicator_uuid: dup.indicator_uuid
        )
        .order(:created_at)

      # Keep the first, remove the rest
      records.offset(1).find_each do |record|
        puts "Deleting voting_indicator id=#{record.id}"
        record.destroy!
      end
    end

    puts "Cleanup completed"
  end
end
