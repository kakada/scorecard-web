# frozen_string_literal: true

class JaapPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    editable_team?
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    editable_team?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.system_admin?
      return scope.where(program_id: user.program_id) if user.program_admin? || user.staff?
      return scope.where(program_id: user.program_id, province_id: user.local_ngo.target_province_ids.to_s.split(",")) if user.lngo?
      scope.none
    end
  end


  private
    def editable_team?
      user.program_admin? || user.staff? || user.lngo?
    end
end
