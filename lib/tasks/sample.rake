# frozen_string_literal: true

require "sample/csc_web"

if Rails.env.development? || Rails.env.test?
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
      Sample::CscWeb.export(args[:json_type])
    end
  end
end
