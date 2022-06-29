# frozen_string_literal: true

class ThematicPolicy < ApplicationPolicy
  def index?
    user.system_admin?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
