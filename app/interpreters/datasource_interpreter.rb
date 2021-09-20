# frozen_string_literal: true

class DatasourceInterpreter < Dashboards::BaseInterpreter
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def interpreted_message
    data = load_json_data("datasource.json")
    data["url"] = ENV["DATASOURCE_URL"]
    data["secureJsonData"]["password"] = ENV["DATASOURCE_PASSWORD"]
    data
  end
end
