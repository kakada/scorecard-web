# frozen_string_literal: true

namespace :program do
  desc "migrate uuid"
  task migrate_uuid: :environment do
    Program.find_each do |program|
      uuid = program.uuid || program.secure_uuid
      program.update_column(:uuid, uuid)
    end
  end

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

  # Usage:
  #   1. Log in as an admin user and create a new program (e.g., "World Vision").
  #   2. In the terminal, run: `rake program:clone_program['ISAF-II','World Vision']`
  #      → This command clones all data from the "ISAF-II" program to the "World Vision" program.
  #   3. After cloning, create a new admin user for the "World Vision" program.
  #   4. Log in as the new program admin user and create one or more Local NGOs.
  #      → This step enables scorecard creation.
  #   5. Create CAFs under each Local NGO (these are the users/CAFs listed in each scorecard within the mobile app who will conduct scorecard sessions with community users).
  #   6. Create web app user accounts for each Local NGO.
  #      → These accounts will log in to the scorecard app using a username and password to download scorecard data for offline use.
  #      → Note: Each LNGO user can only download scorecards associated with their own NGO.
  #
  # Notes:
  #   - Ensure both the source and target programs are created before running this task.
  #   - The target program must be empty to avoid data conflicts. If not, data will be applied with upsert logic.
  desc <<~DESC
    Clone program data from a source program to a target program, case sensitive.
      - Make sure both programs already exist.
      - The target program should be empty before cloning. If not, data is applied with upsert logic.
    Usage:
      rake program:clone_program['source_program_name','target_program_name']
  DESC
  task :clone_program, [:source_program_name, :target_program_name] => :environment do |_task, args|
    source_name = args[:source_program_name].to_s.strip
    target_name = args[:target_program_name].to_s.strip

    if source_name.blank? || target_name.blank?
      abort "❌  Please provide both source and target program names.\nExample: rake program:clone_program['ISAF-II','World Vision']"
    end

    source_program = Program.find_by(name: source_name)
    abort "❌  Source program '#{source_name}' does not exist. Please create it first." unless source_program

    target_program = Program.find_by(name: target_name)
    abort "❌  Target program '#{target_name}' does not exist. Please create it first." unless target_program

    puts "🔄  Cloning data from '#{source_program.name}' → '#{target_program.name}'..."
    ProgramService.new(target_program.id).clone_from_program(source_program)
    puts "✅  Clone completed successfully!"
  end

  desc "remove program and its dependency"
  task :remove_program, [:program_name] => :environment do |task, args|
    abort "This task requires to have a program name!" unless args[:program_name].present?

    program = Program.find_by name: args[:program_name]

    STDOUT.puts "Are you sure to remove the program '#{program.name}'? (y/n)"
    input = STDIN.gets.strip

    abort "You've cancelled removing program #{args[:program_name]}!" unless input.to_s.downcase == "y"

    Program.transaction do
      program.scorecards.with_deleted.each do |scorecard|
        scorecard.facilitators.destroy_all
        scorecard.participants.destroy_all
        scorecard.custom_indicators.destroy_all
        scorecard.raised_indicators.destroy_all
        scorecard.voting_indicators.destroy_all
        scorecard.ratings.destroy_all
        scorecard.scorecard_progresses.delete_all
        scorecard.suggested_actions.destroy_all
        scorecard.scorecard_references.destroy_all
        scorecard.request_changes.destroy_all
        scorecard.indicator_activities.destroy_all
        scorecard.really_destroy!
      end

      program.contacts.destroy_all
      program.pdf_templates.destroy_all
      program.chat_groups.destroy_all #:chat_groups_notifications
      program.messages.destroy_all #:notifications, :chat_groups_notifications
      program.mobile_tokens.delete_all
      program.activity_logs.delete_all
      program.data_publication.try(:destroy)
      program.data_publication_logs.delete_all
      program.telegram_bot.try(:destroy)
      program.gf_dashboard.try(:destroy)

      program.local_ngos.destroy_all
      program.rating_scales.destroy_all #:language_rating_scales
      program.facilities.destroy_all #:indicators, :languages_indicators
      program.templates.destroy_all #:indicators, :languages_indicators
      program.languages.destroy_all #:languages_indicators

      program.users.with_deleted.each do |user|
        user.really_destroy!
      end

      program.destroy!

      puts "The program '#{program.name}' has been removed successfully!"
    end
  rescue
    abort "Unable to find the program: #{args[:program_name]}"
  end

  private
    def add_dashboard_and_uses(program)
      program.create_dashboard

      users = User.where(actived: true, program_id: program.id)
      users.each do |user|
        user.send(:add_to_dashboard_async) if user.active_for_authentication?
      end
    end
end
