# frozen_string_literal: true

namespace :voting_indicator do
  desc "migrate display_order"
  task migrate_display_order: :environment do
    scorecards = Scorecard.completed.includes(:voting_indicators)
    scorecards.find_each do |scorecard|
      scorecard.voting_indicators.each_with_index do |indi, index|
        indi.update_column(:display_order, index + 1)
      end
    end
  end
end
