# frozen_string_literal: true

require "csv"

module Samples
  class Category < Base
    def self.load
      csv = CSV.read(file_path("category.csv"))
      csv[1..-1].each do |data|
        category = ::Category.find_or_initialize_by(code: data[0])
        category.update(
          name_en: data[1],
          name_km: data[2],
          hierarchy: data[3].split("|")
        )
      end
    end
  end
end
