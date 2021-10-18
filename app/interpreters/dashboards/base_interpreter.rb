# frozen_string_literal: true

module Dashboards
  class BaseInterpreter
    def gsub_program_id(program, str)
      return str unless str.present?

      str.gsub(/\$\{program_id\}/, "#{program.id}")
    end

    def load_json_data(filename)
      file_path = Rails.root.join("public", filename).to_s
      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

      JSON.load File.open(file_path)
    end
  end
end
