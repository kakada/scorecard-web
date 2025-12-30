# frozen_string_literal: true

namespace :onetime do
  namespace :scorecard do
    desc "Safely migrate scorecard & scorecard_progress status enum values (with collision protection)"
    task migrate_status_enum: :environment do
      # ============================================================
      # ENUM MIGRATION STRATEGY
      # ------------------------------------------------------------
      # 1. Move old enum values to a temporary range (+ TEMP_OFFSET)
      # 2. Move temporary values to final enum values
      # This avoids value collisions during migration
      # ============================================================

      TEMP_OFFSET = 100

      # old_value => new_value
      STATUS_MAPPING = {
        5 => 7, # completed
        3 => 6, # in_review
        4 => 3  # renewed
      }.freeze

      # Model => column_name
      TARGETS = {
        ScorecardProgress => :status,
        Scorecard         => :progress
      }.freeze

      def move_status(model, column, from, to)
        count = model.where(column => from).update_all(column => to)
        puts "   #{model.name}: #{count} records moved #{from} → #{to}"
      end

      ActiveRecord::Base.transaction do
        puts "🚀 Starting scorecard status enum migration..."

        # ----------------------------------------------------------
        # STEP 1: Move old values to temporary values
        # ----------------------------------------------------------
        puts "➡️  Step 1: Moving old values to temporary space..."

        STATUS_MAPPING.keys.each do |old_value|
          temp_value = old_value + TEMP_OFFSET

          TARGETS.each do |model, column|
            move_status(model, column, old_value, temp_value)
          end
        end

        # ----------------------------------------------------------
        # STEP 2: Move temporary values to final enum values
        # ----------------------------------------------------------
        puts "➡️  Step 2: Moving temporary values to final enum values..."

        STATUS_MAPPING.each do |old_value, new_value|
          temp_value = old_value + TEMP_OFFSET

          TARGETS.each do |model, column|
            move_status(model, column, temp_value, new_value)
          end
        end

        puts "✅ Scorecard status enum migration completed successfully!"
      end
    rescue StandardError => e
      puts "❌ Migration failed: #{e.message}"
      raise
    end
  end
end
