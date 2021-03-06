# frozen_string_literal: true

require_relative "sample"

module Sample
  class CscWeb
    def self.load_samples
      ::Sample::Program.load
      ::Sample::Location.load
      ::Sample::PrimarySchool.load
      ::Sample::LocalNgo.load
      ::Sample::User.load
      ::ScorecardCriteria::Facility.load
      ::Sample::Indicator.load
      ::Sample::Caf.load
      ::Sample::Scorecard.load
    end

    def self.export(filetype = "json")
      ::Sample::Scorecard.export(filetype)
    end
  end
end
