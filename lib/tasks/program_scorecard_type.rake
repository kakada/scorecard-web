# frozen_string_literal: true

namespace :program_scorecard_type do
  desc "migrate scorecard type for all programs"
  task migrate_scorecard_type_for_all_programs: :environment do
    Program.all.each do |program|
      program.create_program_scorecard_types
    end
  end
end
