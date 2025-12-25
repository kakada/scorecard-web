# frozen_string_literal: true

class JaapPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if user.system_admin?
    return true if (user.program_admin? || user.staff?) && (user.program_id == record.program_id)
    
    false
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def complete?
    create?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
