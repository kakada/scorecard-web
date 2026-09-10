# frozen_string_literal: true

# Usage: rake indicator_activity_category:seed

namespace :indicator_activity_category do
  desc "Seed standard waste management categories for indicator activities"
  task seed: :environment do
    program = Program.find_by name: "Plastic Smart"
    return unless program

    puts "Seeding standard waste management categories for program: #{program.name}"

    file = Rails.root.join("db", "seeds", "indicator_activity_category", "standard_waste_management_category.json")

    categories = JSON.parse(File.read(file))

    categories.each do |attrs|
      category = IndicatorActivityCategory.find_or_initialize_by(name_en: attrs["name_en"], program: program)
      category.update!(attrs.merge(program: program))
    end

    puts "Standard waste management categories seeded successfully with #{categories.size} categories."
  end
end
