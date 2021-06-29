# frozen_string_literal: true

class MobileTokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
