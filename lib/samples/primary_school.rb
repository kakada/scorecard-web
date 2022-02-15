# frozen_string_literal: true

require "csv"

module Samples
  class PrimarySchool < Base
    def self.load
      Spreadsheets::PrimarySchoolSpreadsheet.new.import(file_path("primary_schools.xlsx"))
    end

    def self.export(type = "json")
      class_name = "Exporters::#{type.camelcase}Exporter"
      class_name.constantize.new(::PrimarySchool.all).export("primary_schools")
    rescue
      Rails.logger.warn "#{class_name} is unknwon"
    end
  end
end
