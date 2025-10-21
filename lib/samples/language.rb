# frozen_string_literal: true

module Samples
  class Language < Base
    def self.load(program_name = "ISAF-II")
      program = ::Program.find_by name: program_name
      return if program.nil?

      csv = CSV.read(file_path("language.csv"))
      csv.shift
      csv.each do |data|
        language = program.languages.find_or_initialize_by(code: data[0])
        language.update(name_en: data[1], name_km: data[2])
      end
    end
  end
end
