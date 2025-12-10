# frozen_string_literal: true

class ProgramClonePolicy < ApplicationPolicy
  def new?
    user.system_admin?
  end

  def select_method?
    new?
  end

  def select_component?
    new?
  end

  def review?
    new?
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def show?
    user.system_admin? || record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
