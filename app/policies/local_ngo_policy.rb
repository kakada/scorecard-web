# frozen_string_literal: true

class LocalNgoPolicy < ApplicationPolicy
  def index?
    user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def update?
    user.program_admin?
  end

  def destroy?
    user.program_admin?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
