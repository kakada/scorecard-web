# frozen_string_literal: true

class IndicatorActivityCategoryPolicy < ApplicationPolicy
  def index?
    user.program_admin? || user.staff?
  end

  def create?
    index?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      return scope.where(program_id: user.program_id) if user.program_admin? || user.staff?

      scope.none
    end
  end
end
