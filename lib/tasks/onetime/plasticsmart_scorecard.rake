# frozen_string_literal: true

# Usage
#   rake onetime:plasticsmart_scorecard:migrate_type_to_combined_scorecard

namespace :onetime do
  namespace :plasticsmart_scorecard do
    desc "Safely migrate scorecard type enum values to combined_scorecard for Plastic Smart program"
    task migrate_type_to_combined_scorecard: :environment do
      program = Program.find_by(name: "Plastic Smart")

      unless program.present?
        puts "❌ Program 'Plastic Smart' not found. Aborting migration."
        next
      end

      program.create_program_scorecard_types

      scorecards = Scorecard.where("created_at < ?", Date.new(2026, 9, 10))
                            .where(program_id: program.id)

      count = scorecards.update_all(scorecard_type: Scorecard.scorecard_types[:combined_scorecard])

      puts "✅ Migrated #{count} scorecard(s) for program 'Plastic Smart' to combined_scorecard."
    rescue StandardError => e
      puts "❌ Migration failed: #{e.message}"
      raise
    end
  end
end
