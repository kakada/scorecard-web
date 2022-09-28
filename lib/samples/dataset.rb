# frozen_string_literal: true

require "csv"

module Samples
  class Dataset < Base
    def self.load
      categories = [
        { code: "D_PS", filename: "primary_schools.xlsx" },
        { code: "D_HC", filename: "health_centers.xlsx" },
        { code: "D_FA", filename: "factories.xlsx" }
      ]

      categories.each do |cate|
        category = ::Category.find_by(code: cate[:code])

        ::DatasetSpreadsheet.new(category).import(file_path(cate[:filename]))
      end
    end
  end
end
