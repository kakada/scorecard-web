# frozen_string_literal: true

class UserGuidePolicy < ApplicationPolicy
  def index?
    # All authenticated users can access user guides
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
