# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin? || user.staff?
  end

  def create?
    user.system_admin? || user.program_admin? || user.staff?
  end

  def update?
    create?
  end

  def archive?
    return false if record.id == user.id
    return true if user.system_admin? || (user.program_admin? && !record.system_admin?) || (user.staff? && record.lngo?)
    false
  end

  def restore?
    record.deleted?
  end

  def destroy?
    archive? && record.deleted? &&
    record.mobile_notifications.length.zero? && record.scorecards.length.zero?
  end

  def unlock_access?
    update?
  end

  def roles
    return User::ROLES if user.system_admin?
    return [["Lngo", "lngo"]] if user.staff?

    User::ROLES[1..-1]
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?
      return scope.where(role: :lngo).where(program_id: user.program_id) if user.staff?

      scope.where(program_id: user.program_id)
    end
  end
end
