# frozen_string_literal: true

# Usage: rake static_pages:seed_fam_reporting

namespace :static_pages do
  desc "Seed FAM reporting static pages"
  task seed_fam_reporting: :environment do
    slug = "/fam_reporting"
    base_path = Rails.root.join("db", "seeds", "static_pages", "fam_reporting")

    content_en = File.read(base_path.join("content_en.html"))
    content_km = File.read(base_path.join("content_km.html"))

    page = StaticPage.find_or_initialize_by(slug: slug)
    page.content_en = content_en
    page.content_km = content_km
    page.save!

    puts "Seeded static page '#{slug}' (id: #{page.id})"
  end
end
