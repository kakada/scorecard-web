# frozen_string_literal: true

module Dashboards
  class VariableInterpreter < BaseInterpreter
    def initialize(program, data)
      @program = program
      @data = data
    end

    def interpret
      @data["templating"]["list"].each do |template|
        template["definition"] = gsub_program_id(@program, template["definition"])
        template["query"] = gsub_program_id(@program, template["query"])
      end
    end
  end
end
