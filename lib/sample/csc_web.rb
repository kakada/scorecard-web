# frozen_string_literal: true

require_relative 'user'
require_relative 'scorecard'

module Sample
  class CscWeb
    def self.load_samples
      ::Sample::User.load
      ::Sample::PredefinedIssue.load
      ::Sample::Scorecard.load
    end
  end
end
