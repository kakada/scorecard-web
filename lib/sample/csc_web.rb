# frozen_string_literal: true

require_relative "user"
require_relative "program"
require_relative "facility"
require_relative "indicator"
require_relative "local_ngo"
require_relative "caf"
require_relative "location"
require_relative "scorecard"

module Sample
  class CscWeb
    def self.load_samples
      ::Sample::Program.load
      ::Sample::Location.load
      ::Sample::User.load
      ::Sample::Facility.load
      ::Sample::Indicator.load
      ::Sample::LocalNgo.load
      ::Sample::Caf.load
      ::Sample::Scorecard.load
    end
  end
end
