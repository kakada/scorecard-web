# frozen_string_literal: true

require_relative "scorecard_criteria"

module ScorecardCriteria
  class Facility < ::ScorecardCriteria::Base
    def self.load
      program = ::Program.find_by name: "CARE"
      return if program.nil?

      csv = CSV.read(file_path("facility.csv"))
      csv.shift
      csv.each do |data|
        facility = program.facilities.find_or_initialize_by(code: data[0])
        facility.name = data[1]
        facility.parent_id = program.facilities.find_by(code: data[2]).id if data[2].present?
        facility.save
      end
    end
  end
end
