# frozen_string_literal: true

module ProgramsHelper
  def program_scorecard_types
    return Scorecard.t_scorecard_types unless current_program.present?

    current_program.program_scorecard_types.pluck(:"name_#{I18n.locale}", :code)
  end
end
