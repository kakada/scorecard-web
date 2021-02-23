# frozen_string_literal: true

module Sample
  class Facility
    def self.load
      program = ::Program.find_by name: "CARE"
      health = program.facilities.create(name: "Health", code: "HE")
      education = program.facilities.create(name: "Education", code: "ED")

      health.children.create(name: "Health Center", program_id: program.id, code: "HC")
      education.children.create(name: "Primary School", program_id: program.id, code: "PS", subset: ::Facility::SUBSETS.first[:code])
    end
  end
end
