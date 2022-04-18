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
