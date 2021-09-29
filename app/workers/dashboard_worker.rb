# frozen_string_literal: true

class DashboardWorker
  include Sidekiq::Worker

  def perform(program_id)
    program = Program.find_by(id: program_id)
    program.create_dashboard if program.present?
  end
end
