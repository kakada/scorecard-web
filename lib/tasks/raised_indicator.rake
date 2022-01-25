# frozen_string_literal: true

namespace :raised_indicator do
  desc "migrate indicator_uuid"
  task migrate_indicator_uuid: :environment do
    RaisedIndicator.includes(:indicatorable).find_each do |ri|
      ri.update(indicator_uuid: ri.indicatorable.uuid)
    end
  end
end
