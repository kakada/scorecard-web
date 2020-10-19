# frozen_string_literal: true

module Sample
  class ScorecardType
    def self.load
      program = ::Program.find_by(name: "CARE")
      names = ["Self assessment", "Community Scorecard"]
      names.each do |name|
        program.scorecard_types.create(name: name)
      end
    end
  end
end
