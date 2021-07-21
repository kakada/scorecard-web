# frozen_string_literal: true

class MobileNotificationPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin? || user.staff?
  end

  def create?
    index?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?

      scope.where(program_id: user.program_id)
    end
  end
end
