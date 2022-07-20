# frozen_string_literal: true

class PrimarySchoolPolicy < ApplicationPolicy
  def index?
    true
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
