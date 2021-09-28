# frozen_string_literal: true

class DatasourceInterpreter < Dashboards::BaseInterpreter
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def interpreted_message
    data = load_json_data("datasource.json")
    data["type"]     = ENV["GF_DATASOURCE_TYPE"]
    data["url"]      = ENV["GF_DATASOURCE_URL"]
    data["database"] = ENV["GF_DATASOURCE_DATABASE"]
    data["user"]     = ENV["GF_DATASOURCE_USER"]
    data["secureJsonData"]["password"] = ENV["GF_DATASOURCE_PASSWORD"]
    data
  end
end
