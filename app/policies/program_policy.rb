# frozen_string_literal: true

class ProgramPolicy < ApplicationPolicy
  def index?
    user.system_admin?
  end

  def create?
    user.system_admin?
  end

  def update?
    user.system_admin? || user.program_admin?
  end

  def destroy?
    user.system_admin?
  end

  def es_reindex?
    user.system_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
