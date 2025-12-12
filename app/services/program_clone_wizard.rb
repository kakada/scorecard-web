# frozen_string_literal: true

class ProgramCloneWizard
  def initialize(session, program)
    @session = session
    @key = "program_clone_wizard_#{program.id}"
  end

  def data
    @session[@key] ||= {}
    @session[@key].with_indifferent_access
  end

  def update(attrs)
    @session[@key] ||= {}
    @session[@key].merge!(attrs.stringify_keys)
  end

  def clear
    @session.delete(@key)
  end
end
