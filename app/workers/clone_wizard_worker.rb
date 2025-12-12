# frozen_string_literal: true

class CloneWizardWorker
  include Sidekiq::Worker

  def perform(program_clone_id)
    program_clone = ProgramClone.find_by(id: program_clone_id)
    return unless program_clone

    program_clone.update(status: "processing")

    begin
      service = WizardProgramService.new(
        program_clone.target_program_id,
        program_clone.selected_components
      )

      if program_clone.clone_from_sample?
        service.clone_from_sample
      elsif program_clone.clone_from_program?
        unless program_clone.source_program_id.present?
          raise StandardError, "Source program ID is required for program clone method"
        end

        source_program = Program.find(program_clone.source_program_id)
        service.clone_from_program(source_program)
      else
        raise StandardError, "Invalid clone method: #{program_clone.clone_method}"
      end

      program_clone.update(status: "completed", completed_at: Time.current)
    rescue StandardError => e
      program_clone.update(status: "failed", error_message: e.message)
      raise e
    end
  end
end
