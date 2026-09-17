# frozen_string_literal: true

# Usage:
#   rake dashboard:reset_dashboard
#   Or
#   rails dashboard:reset_dashboard
# Note: This assumes that grafana has start new volume before running this task.

namespace :dashboard do
  desc "Delete every GfDashboard record and recreate all Grafana dashboards and users from scratch"
  task reset_dashboard: :environment do
    GfDashboard.delete_all
    User.update_all(gf_user_id: nil)

    Program.find_each do |program|
      program.create_dashboard
      puts "Created dashboard for program: #{program.name}"
    end

    User.where.not(program_id: nil).find_each do |user|
      user.add_to_dashboard
      puts "Added user to dashboard: #{user.email}"
    end
  end
end
