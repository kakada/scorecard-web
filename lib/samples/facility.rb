# frozen_string_literal: true

module Samples
  class Facility < Base
    def self.load(program_name="CARE")
      program = ::Program.find_by name: program_name
      return if program.nil?

      csv = CSV.read(file_path("facility.csv"))
      csv.shift
      csv.each do |data|
        facility = program.facilities.find_or_initialize_by(code: data[0])
        facility.name_en = data[1]
        facility.name_km = data[2]
        facility.parent_id = program.facilities.find_by(code: data[3]).id if data[3].present?
        facility.default = data[4]
        facility.dataset = data[5]
        facility.save
      end
    end
  end
end
