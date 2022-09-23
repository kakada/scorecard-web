# frozen_string_literal: true

require_relative "sample"

module Samples
  class CscWeb
    def self.load_samples
      ::Samples::Program.load
      ::Samples::Language.load
      ::Samples::PdfTemplate.load
      ::Samples::Location.load
      ::Samples::Category.load
      ::Samples::Dataset.load
      ::Samples::LocalNgo.load
      ::Samples::User.load
      ::Samples::Facility.load
      ::Samples::Indicator.load
      ::Samples::Caf.load
      ::Samples::RatingScale.load
      ::Samples::EducationalBackground.load
      ::Samples::ScorecardKnowledge.load

      ::Samples::Scorecard.load
    end

    def self.export(filetype = "json")
      ::Samples::Scorecard.export(filetype)
    end
  end
end
