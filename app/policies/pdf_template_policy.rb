# frozen_string_literal: true

class PdfTemplatePolicy < ApplicationPolicy
  def index?
    user.program_admin? || user.staff?
  end

  def create?
   index?
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
