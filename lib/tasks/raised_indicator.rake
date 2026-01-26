# frozen_string_literal: true

namespace :raised_indicator do
  desc "migrate indicator_uuid (DEPRECATED - indicatorable association removed)"
  task migrate_indicator_uuid: :environment do
    puts "WARNING: This task is deprecated. The indicatorable association has been removed."
    puts "Use indicator_uuid directly instead."
  end

  desc "migrate missing indicator in raised indicator and voting indicator (DEPRECATED)"
  task migrate_missing_raised_and_voting_indicator: :environment do
    puts "WARNING: This task is deprecated. The indicatorable association has been removed."
    puts "Use indicator_uuid directly instead."
  end
end
