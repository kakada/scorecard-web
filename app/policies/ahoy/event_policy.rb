# frozen_string_literal: true

class Ahoy::EventPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin? || user.staff?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin? || user.program_admin? || user.staff?

      scope.none
    end
  end
end
