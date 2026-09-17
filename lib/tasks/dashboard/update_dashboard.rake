# frozen_string_literal: true

# Usage:
#   rake dashboard:update_dashboard
#   Or
#   rails dashboard:update_dashboard

namespace :dashboard do
  desc "Update all Grafana dashboards for all programs"
  task update_dashboard: :environment do
    Program.find_each do |program|
      program.update_dashboard
      puts "Updated dashboard for program: #{program.name}"
    end
  end
end
