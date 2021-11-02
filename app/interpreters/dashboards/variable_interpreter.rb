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

        hide_variable_program(template)
      end
    end

    private
      def hide_variable_program(template)
        template["hide"] = 2 if template["name"] == "program_id"
      end
  end
end
