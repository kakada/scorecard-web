# frozen_string_literal: true

namespace :program do
  desc "migrate short name"
  task migrate_shortcut_name: :environment do
    Program.find_each do |program|
      program.update_column(:shortcut_name, program.name[0..9])
    end
  end

  desc "migrate dashboard for program"
  task :migrate_dashboard, [:program_id] => :environment do |task, args|
    program = Program.find(args[:program_id])

    add_dashboard_and_uses(program)
  rescue
    abort "Unable to find the program: #{args[:program_id]}"
  end

  desc "migrate dashboard for each programs"
  task migrate_each_dashboard: :environment do
    Program.find_each do |program|
      add_dashboard_and_uses(program)
    end
  end

  desc "migrate uuid for references"
  task migrate_program_uuid_for_references: :environment do
    klasses = [
      "ChatGroup",
      "Contact",
      "Facility",
      "Language",
      "LocalNgo",
      "Message",
      "MobileNotification",
      "MobileToken",
      "Notification",
      "PdfTemplate",
      "RatingScale",
      "Scorecard",
      "TelegramBot",
      "Template",
      "User",
      "ActivityLog",
      "GfDashboard"
    ]

    klasses.each do |klass|
      update_program_uuid(klass)
    end
  end

  private
    def add_dashboard_and_uses(program)
      program.create_dashboard

      users = User.where(actived: true, program_id: program.id)
      users.each do |user|
        user.send(:add_to_dashboard_async) if user.active_for_authentication?
      end
    end

    def update_program_uuid(klass)
      Program.all.each do |program|
        collection = klass.constantize.where(program_id: program.id)
        collection.update_all(program_uuid: program.uuid)
      end
    end
end
