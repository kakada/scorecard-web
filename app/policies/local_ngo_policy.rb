# frozen_string_literal: true

class LocalNgoPolicy < ApplicationPolicy
  def index?
    user.program_admin? || user.staff? || user.lngo?
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    create?
  end

  def manage_caf?
    create? || record.id == user.local_ngo_id
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?
      return scope.where(id: user.local_ngo_id) if user.lngo?

      scope.where(program_id: user.program_id)
    end
  end
end
