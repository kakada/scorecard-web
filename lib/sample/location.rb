# frozen_string_literal: true

require "csv"

module Sample
  class Location
    def self.load
      file_path = Rails.root.join("lib", "sample", "assets", "csv", "locations.csv").to_s

      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      csv = CSV.read(file_path)
      csv.shift
      csv.each do |data|
        loc = ::Location.find_or_initialize_by(code: data[0])
        loc.name_en = data[1]
        loc.name_km = data[2]
        loc.kind = data[3]
        loc.parent_id = data[4]

        if data[5].present? && data[6].present?
          loc.latitude = data[5]
          loc.longitude = data[6]
          loc.osm_latitude = data[7]
          loc.osm_longitude = data[8]
        end

        loc.save
      end
    end
  end
end
