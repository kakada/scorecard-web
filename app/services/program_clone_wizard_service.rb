# frozen_string_literal: true

class ProgramCloneWizardService
  attr_reader :program, :user, :wizard, :wizard_data, :program_clone

  def initialize(program, user, session)
    @program = program
    @user = user
    @wizard = ProgramCloneWizard.new(session, program)
    @wizard_data = @wizard.data
    build_program_clone
  end

  # =====================
  # Step validations
  # =====================
  def valid_select_method?(params)
    clone_method = params[:clone_method]
    source_program_id = params[:source_program_id]

    return false if clone_method.blank? || (clone_method == "program" && source_program_id.blank?)

    wizard.update(clone_method: clone_method, source_program_id: source_program_id)
    true
  end

  def valid_choose_components?(selected_components)
    components = selected_components&.reject(&:blank?)
    return false if components.blank?

    wizard.update(selected_components: components)
    true
  end

  # =====================
  # Build & Save ProgramClone
  # =====================
  def build_program_clone
    @program_clone = ProgramClone.new(
      target_program: program,
      user: user,
      clone_method: wizard_data[:clone_method],
      source_program_id: wizard_data[:source_program_id],
      selected_components: wizard_data[:selected_components]
    )
  end

  def save_program_clone
    if @program_clone.save
      wizard.clear
      CloneWizardWorker.perform_async(@program_clone.id)
      true
    else
      false
    end
  end
end
