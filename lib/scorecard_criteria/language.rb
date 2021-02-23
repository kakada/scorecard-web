# frozen_string_literal: true

require_relative "scorecard_criteria"

module ScorecardCriteria
  class Language < ::ScorecardCriteria::Base
    def self.load
      program = ::Program.find_by name: "CARE"
      return if program.nil?

      csv = CSV.read(file_path("language.csv"))
      csv.shift
      csv.each do |data|
        loc = program.languages.find_or_initialize_by(code: data[0])
        loc.update(name_en: data[1], name_km: data[2])
      end
    end
  end
end
