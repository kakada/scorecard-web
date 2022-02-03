# frozen_string_literal: true

require "samples/sample"

namespace :scorecard_criteria do
  desc "Loads sample data"
  task load: :environment do
    Samples::Scorecards::Language.load
    Samples::Scorecards::Facility.load
    Samples::Scorecards::Indicator.load
    Samples::Scorecards::RatingScale.load
  end
end
