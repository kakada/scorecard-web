namespace :indicator_action do
  desc "migrate from indicator activity"
  task migrate_from_indicator_activity: :environment do
    IndicatorActivity.includes(voting_indicator: :scorecard).find_each do |indicator_activity|
      indicator_activity.send(:create_proposed_indicator_actions)
    end
  end
end
