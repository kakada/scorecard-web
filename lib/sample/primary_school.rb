# frozen_string_literal: true

require "csv"

module Sample
  class PrimarySchool
    def self.load
      file_path = Rails.root.join("lib", "sample", "assets", "csv", "primary_schools.csv").to_s

      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      csv = CSV.read(file_path)
      csv.shift
      csv.each do |data|
        loc = ::PrimarySchool.find_or_initialize_by(code: data[0])
        loc.name_en = data[1]
        loc.name_km = data[2]
        loc.commune_id = data[3]
        loc.save
      end
    end
  end
end
