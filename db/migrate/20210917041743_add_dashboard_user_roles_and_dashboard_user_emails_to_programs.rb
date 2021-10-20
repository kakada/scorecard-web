# frozen_string_literal: true

class AddDashboardUserRolesAndDashboardUserEmailsToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :dashboard_user_emails, :text, array: true, default: []
    add_column :programs, :dashboard_user_roles, :string, array: true, default: []
  end
end
