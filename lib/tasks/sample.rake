# frozen_string_literal: true

require "sample/csc_web"

if ENV["ENABLE_RESET_DATA_SCHEDULE"] == "true" || Rails.env.development? || Rails.env.test?
  namespace :sample do
    desc "Clean db"
    task clean_db: :environment do
      require "database_cleaner"

      DatabaseCleaner[:active_record].strategy = :truncation
      DatabaseCleaner[:active_record].start
      DatabaseCleaner[:active_record].clean
    end

    desc "Loads sample data"
    task load: [:clean_db] do
      Sample::CscWeb.load_samples
    end

    desc "Loads sample data"
    task :export, [:json_type] => :environment do |task, args|
      filetype = args[:json_type] || "json"
      Sample::CscWeb.export(filetype)
    end

    desc "Simulate scorecard data"
    task :load_scorecard, [:count] => :environment do |task, args|
      count = (args[:count] || 1).to_i
      ::Sample::Scorecard.load(count)
    end
  end
end
