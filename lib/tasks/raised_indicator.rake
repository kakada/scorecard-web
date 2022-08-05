# frozen_string_literal: true

namespace :raised_indicator do
  desc "migrate indicator_uuid"
  task migrate_indicator_uuid: :environment do
    RaisedIndicator.includes(:indicatorable).find_each do |ri|
      ri.update(indicator_uuid: ri.indicatorable.uuid)
    end
  end

  desc "migrate missing indicator in raised indicator and voting indicator"
  task migrate_missing_raised_and_voting_indicator: :environment do
    ["RaisedIndicator", "VotingIndicator"].each do |klass_name|
      collection = klass_name.constantize.where.not(indicator_uuid: Indicator.pluck(:uuid)).includes(:indicatorable)

      update_missing_indicator_uuid(collection)
    end
  end

  private
    def update_missing_indicator_uuid(collection)
      collection.each do |ri|
        params = { indicator_uuid: ri.indicatorable.uuid }
        params.merge({ indicatorable_type: "Indicators::CustomIndicator" }) if ri.indicatorable_type == "CustomIndicator"

        ri.update_columns(params)
      end
    end
end
