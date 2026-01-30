# frozen_string_literal: true

class MigrateAgeDataFromDateOfBirth < ActiveRecord::Migration[7.0]
  def up
    # Calculate age from date_of_birth for existing records
    Caf.find_each do |caf|
      next if caf.date_of_birth.blank?
      
      begin
        # Parse date_of_birth and calculate age
        dob = Date.parse(caf.date_of_birth)
        today = Date.today
        age = today.year - dob.year - ((today.month > dob.month || (today.month == dob.month && today.day >= dob.day)) ? 0 : 1)
        caf.update_column(:age, age) if age >= 0
      rescue ArgumentError, TypeError
        # Skip records with invalid date formats
        Rails.logger.warn "Skipping CAF ID #{caf.id} due to invalid date_of_birth: #{caf.date_of_birth}"
      end
    end
  end

  def down
    # No need to revert, age can be recalculated from date_of_birth if needed
  end
end
