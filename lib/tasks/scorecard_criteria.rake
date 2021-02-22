# frozen_string_literal: true

require "scorecard_criteria/scorecard_criteria"

namespace :scorecard_criteria do
  desc "Loads sample data"
  task load: :environment do
    ScorecardCriteria::Language.load
    ScorecardCriteria::Facility.load
    ScorecardCriteria::Indicator.load
    ScorecardCriteria::RatingScale.load
  end
end
