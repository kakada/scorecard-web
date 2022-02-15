# frozen_string_literal: true

require "csv"

module Samples
  class Base
    def self.file_path(file_name)
      file_path = Rails.root.join("lib", "samples", "assets", "csv", file_name).to_s

      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      file_path
    end

    def self.get_audio(language, row)
      column = "#{language.name_en} (#{language.code})" # Khmer (km)

      if filename = row[column].presence
        audios.select { |file| file.split("/").last.split(".").first == "#{filename.split('.').first}" }.first
      end
    end

    def self.audios
      @audios ||= Dir.glob(Rails.root.join("lib", "samples", "assets", "audios", "**", "**", "**", "**"))
    end
  end
end
