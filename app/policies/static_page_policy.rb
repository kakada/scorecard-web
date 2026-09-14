# frozen_string_literal: true

class StaticPagePolicy < ApplicationPolicy
  def index?
    user&.system_admin?
  end

  def show?
    index?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
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
      return scope.all if user&.system_admin?

      scope.none
    end
  end
end
