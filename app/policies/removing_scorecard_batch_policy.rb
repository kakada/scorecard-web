# frozen_string_literal: true

class RemovingScorecardBatchPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.system_admin? || user.program_admin? && (record.program_id == user.program_id)
  end

  def create?
    user.program_admin?
  end

  def update?
    false
  end

  def destroy?
    recored.scorecards.blank?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
