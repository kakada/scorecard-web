# frozen_string_literal: true

class RemovingScorecardBatchPolicy < ApplicationPolicy
  def index?
    user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
