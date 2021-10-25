# frozen_string_literal: true

namespace :scorecard do
  desc "migrate milestone"
  task migrate_milestone: :environment do
    Scorecard.find_each do |scorecard|
      scorecard.update_column(:progress, scorecard.milestone)
    end
  end
end
