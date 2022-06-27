# frozen_string_literal: true

class IndicatorActionPolicy < ApplicationPolicy
  def index?
    user.program_admin? || user.staff?
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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
