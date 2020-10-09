class CategoryPolicy < ApplicationPolicy
  def create?
    user.program_admin?
  end

  def update?
    user.program_admin?
  end

  def destroy?
    user.program_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
