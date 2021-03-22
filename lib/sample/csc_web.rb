# frozen_string_literal: true

require_relative "sample"

module Sample
  class CscWeb
    def self.load_samples
      ::Sample::Program.load
      ::ScorecardCriteria::Language.load
      ::Sample::Location.load
      ::Sample::PrimarySchool.load
      ::Sample::LocalNgo.load
      ::Sample::User.load
      ::ScorecardCriteria::Facility.load
      ::ScorecardCriteria::Indicator.load
      ::Sample::Caf.load
      ::ScorecardCriteria::RatingScale.load
      ::Sample::Scorecard.load
    end

    def self.export(filetype = "json")
      ::Sample::Scorecard.export(filetype)
    end
  end
end
