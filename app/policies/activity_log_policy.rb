# frozen_string_literal: true

class ActivityLogPolicy < ApplicationPolicy
  def index?
    user.system_admin?
  end
end
