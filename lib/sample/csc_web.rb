# frozen_string_literal: true

require_relative "user"
require_relative "program"
require_relative "category"
require_relative "indicator"
require_relative "local_ngo"
require_relative "caf"
require_relative "scorecard_type"
require_relative "scorecard"

module Sample
  class CscWeb
    def self.load_samples
      ::Sample::Program.load
      ::Sample::User.load
      ::Sample::Category.load
      ::Sample::Indicator.load
      ::Sample::LocalNgo.load
      ::Sample::Caf.load
      ::Sample::ScorecardType.load
      # ::Sample::RaisedPerson.load
      # ::Sample::RaisedIssue.load
      # ::Sample::Scorecard.load
    end
  end
end
