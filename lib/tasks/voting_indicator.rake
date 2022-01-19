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

  desc "migrate to indicator activity"
  task migrate_indicator_activity: :environment do
    VotingIndicator.find_each do |vi|
      migrate_suggested_action(vi)
      migrate_strength(vi)
      migrate_weakness(vi)
    end
  end

  private
    def migrate_suggested_action(voting_indicator)
      voting_indicator.suggested_actions.each do |suggested|
        SuggestedIndicatorActivity.create(suggested.attributes.except(*["id"]))
      end
    end

    def migrate_strength(voting_indicator)
      voting_indicator.strength.each do |str|
        create_indicator(voting_indicator, str, "StrengthIndicatorActivity")
      end
    end

    def migrate_weakness(voting_indicator)
      voting_indicator.weakness.each do |str|
        create_indicator(voting_indicator, str, "WeaknessIndicatorActivity")
      end
    end

    def create_indicator(voting_indicator, content, type)
      IndicatorActivity.create(
        voting_indicator_uuid: voting_indicator.uuid,
        scorecard_uuid: voting_indicator.scorecard_uuid,
        content: content,
        type: type
      )
    end

    def update_selected_indicator(scorecard)
      scorecard.voting_indicators.each do |vi|
        raised_indicators = scorecard.raised_indicators.where(indicatorable_id: vi.indicatorable_id, indicatorable_type: vi.indicatorable_type)
        raised_indicators.update_all(voting_indicator_uuid: vi.uuid, selected: true)
      end
    end
end
