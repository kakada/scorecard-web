# frozen_string_literal: true

# lib/tasks/villages.rake
require "axlsx"

namespace :villages do
  desc "Export village data to tmp/villages.xlsx"
  task export: :environment do
    output = Rails.root.join("tmp", "villages.xlsx")

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "Villages") do |sheet|
        # Header row
        sheet.add_row [
          "location_id",
          "code",
          "name_en",
          "name_km"
        ]

        # Fetch Pumi communes (Pumi::Commune) for village name "All" option
        Pumi::Commune.all.each do |commune|
          sheet.add_row [
            commune.id,
            "#{commune.id}00",
            "All",
            "ទាំងអស់"
          ], types: [:string, :string, :string, :string]
        end

        # Fetch Pumi villages (Pumi::Village)
        Pumi::Village.all.each do |village|
          sheet.add_row [
            village.commune_id,
            village.id,
            village.name_en,
            village.name_km
          ], types: [:string, :string, :string, :string]
        end
      end

      p.serialize(output.to_s)
    end

    puts "✅ Exported villages to #{output}"
  rescue
    abort "❌ Failed to export villages"
  end
end
