# frozen_string_literal: true

module Sample
  class Category
    def self.load
      program = ::Program.find_by name: 'CARE'
      health = program.categories.create(name: 'Health')
      education = program.categories.create(name: 'Education')

      health.children.create(name: 'Health Care Center', program_id: program.id)
      education.children.create(name: 'Primary School', program_id: program.id)
    end
  end
end
