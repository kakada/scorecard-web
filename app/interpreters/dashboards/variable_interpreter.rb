# frozen_string_literal: true

module Dashboards
  class VariableInterpreter < BaseInterpreter
    LABEL_TRANSLATIONS = {
      "province_id" => { "km" => "ខេត្ត", "en" => "Province" },
      "year" => { "km" => "ឆ្នាំ", "en" => "Year" },
      "facility_name" => { "km" => "សេវា", "en" => "Sector" },
      "facility_id" => { "km" => "សេវា", "en" => "Sector" },
      "scorecard_type" => { "km" => "ប្រភេទប័ណ្ណដាក់ពិន្ទុ", "en" => "Scorecard Type" },
      "locale" => { "km" => "ភាសា", "en" => "Language" }
    }.freeze

    def initialize(program, data, locale = GfDashboard::LOCALES.first)
      @program = program
      @data = data
      @locale = locale
    end

    def interpret
      @data["templating"]["list"].each do |template|
        template["definition"] = gsub_program_id(@program, template["definition"])
        template["query"] = gsub_program_id(@program, template["query"])

        hide_variable_program(template)
        interpret_variable_label(template)
        interpret_variable_locale(template)
        template.delete("datasource")
      end
    end

    private
      def hide_variable_program(template)
        template["hide"] = 2 if template["name"] == "program_id"
      end

      def interpret_variable_label(template)
        translation = LABEL_TRANSLATIONS[template["name"]]
        template["label"] = translation[@locale] if translation
      end

      def interpret_variable_locale(template)
        return unless template["name"] == "locale"

        template["hide"] = 2

        (template["options"] || []).each { |option| option["selected"] = (option["value"] == @locale) }

        selected_option = (template["options"] || []).find { |option| option["value"] == @locale }
        return if selected_option.blank?

        template["current"] = { "selected" => true, "text" => selected_option["text"], "value" => selected_option["value"] }
      end
  end
end
