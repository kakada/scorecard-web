# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  def index?
    user.system_admin?
  end

  def create?
    user.system_admin?
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
