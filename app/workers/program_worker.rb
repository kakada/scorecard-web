# frozen_string_literal: true

class ProgramWorker
  include Sidekiq::Worker

  def perform(program_id)
    program = Program.find_by(id: program_id)
    program.create_index if program.present?
  end
end
