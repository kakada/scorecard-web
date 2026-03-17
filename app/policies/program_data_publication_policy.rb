# frozen_string_literal: true

class ProgramDataPublicationPolicy < ApplicationPolicy
  def update?
    user.program_admin_for?(record) && Settings.program["data_publishable"] == "true"
  end
end
