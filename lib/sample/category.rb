# frozen_string_literal: true

module Sample
  class Category
    def self.load
      program = ::Program.find_by name: "CARE"
      health = program.categories.create(name: "Health", code: "H")
      education = program.categories.create(name: "Education", code: "E")

      health.children.create(name: "Health Center", program_id: program.id, code: "HC")
      education.children.create(name: "Primary School", program_id: program.id, code: "PS")
    end
  end
end
