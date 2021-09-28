# frozen_string_literal: true

class DatasourceInterpreter < Dashboards::BaseInterpreter
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def interpreted_message
    data = load_json_data("datasource.json")
    data["url"] = ENV["GF_DATASOURCE_PG_URL"]
    data["database"] = ENV["GF_DATASOURCE_PG_DATABASE"]
    data["user"] = ENV["GF_DATASOURCE_PG_USER"]
    data["secureJsonData"]["password"] = ENV["GF_DATASOURCE_PG_PASSWORD"]
    data
  end
end
