# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin?
  end

  def create?
    user.system_admin? || user.program_admin?
  end

  def update?
    create?
  end

  def destroy?
    return false if record.id == user.id
    return true if user.system_admin? || (user.program_admin? && !record.system_admin?)
    false
  end

  def unlock_access?
    update?
  end

  def roles
    if user.system_admin?
      User::ROLES
    else
      User::ROLES[1..-1]
    end
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.where(program_id: user.program_id)
      end
    end
  end
end
