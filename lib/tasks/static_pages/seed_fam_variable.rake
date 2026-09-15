# frozen_string_literal: true

# Usage: rake static_pages:seed_fam_variables

namespace :static_pages do
  desc "Seed FAM reporting static page variables"
  task seed_fam_variables: :environment do
    variables = {
      "CARE_LOGO" => "care_vertical.png",
      "FAM_QR_CODE" => "qr-code.png"
    }

    variables.each do |key, asset_path|
      variable = StaticPageVariable.find_or_initialize_by(key: key)
      variable.update!(
        variable_type: "image",
        image: File.open(Rails.root.join("app/assets/images", asset_path))
      )
    end

    puts "FAM reporting static page variables seeded successfully."
  end
end
