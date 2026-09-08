# frozen_string_literal: true

# Usage:
#   rake dashboard:seed_translation
#   Or
#   rails dashboard:seed_translation

namespace :dashboard do
  desc "Seed dashboard translations from db/seeds/translations/*.yml and update existing translations"
  task seed_translation: :environment do
    translations_dir = Rails.root.join("db", "seeds", "translations")

    Dir.glob(translations_dir.join("*.yml")).each do |file|
      data = YAML.safe_load(File.read(file), permitted_classes: [], permitted_symbols: [], aliases: false)

      puts "\n#{File.basename(file)}"

      data.each do |locale, keys|
        keys.each do |key, label|
          Translation.find_or_initialize_by(key: key.to_s, locale: locale.to_s).tap do |t|
            t.label = label
            t.save!
          end
        end

        puts "  Seeded: #{keys.size} keys for #{locale}"
      end
    end
  end
end
