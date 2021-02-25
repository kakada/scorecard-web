# frozen_string_literal: true

Dir["/app/lib/builders/*.rb"].each { |file| require file }
Dir["/app/lib/exporters/*.rb"].each { |file| require file }

require_relative "user"
require_relative "program"
require_relative "facility"
require_relative "primary_school"
require_relative "indicator"
require_relative "local_ngo"
require_relative "caf"
require_relative "location"
require_relative "participant"
require_relative "voting_indicator"
require_relative "rating"
require_relative "raised_indicator"
require_relative "scorecard"
