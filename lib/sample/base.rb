# frozen_string_literal: true

require "csv"

module Sample
  class Base
    def self.file_path(file_name)
      file_path = Rails.root.join("lib", "sample", "assets", "csv", file_name).to_s

      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      file_path
    end
  end
end
