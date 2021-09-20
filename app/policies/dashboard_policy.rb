# frozen_string_literal: true

class DashboardPolicy < ApplicationPolicy
  def index?
    return false if user.program.nil?

    user.program_admin? ||
    user.program.dashboard_user_roles.include?(user.role) ||
    user.program.dashboard_user_emails.include?(user.email)
  end
end
