# frozen_string_literal: true

class ScorecardPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    create? && !record.access_locked?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?
      return scope.where(local_ngo_id: user.local_ngo_id) if user.lngo?

      scope.where(program_id: user.program_id)
    end
  end
end
