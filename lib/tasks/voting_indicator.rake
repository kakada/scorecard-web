# frozen_string_literal: true

namespace :voting_indicator do
  desc "migrate display_order"
  task migrate_display_order: :environment do
    scorecards = Scorecard.completeds.includes(:voting_indicators)
    scorecards.find_each do |scorecard|
      scorecard.voting_indicators.each_with_index do |indi, index|
        indi.update_column(:display_order, index + 1)
      end
    end
  end

  desc "migrate reference for raised indicator and voting indicator"
  task migrate_reference_with_raised_indicator: :environment do
    scorecards = Scorecard.unscope(where: :deleted_at).completeds.includes(:voting_indicators, :raised_indicators)
    scorecards.find_each do |scorecard|
      update_selected_indicator(scorecard)
    end
  end
end

private
def update_selected_indicator(scorecard)
  scorecard.voting_indicators.each do |vi|
    raised_indicators = scorecard.raised_indicators.where(indicatorable_id: vi.indicatorable_id, indicatorable_type: vi.indicatorable_type)
    raised_indicators.update_all(voting_indicator_uuid: vi.uuid, selected: true)
  end
end
