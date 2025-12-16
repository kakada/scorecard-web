# frozen_string_literal: true

module Samples
  class Indicator < Base
    def self.load(program_name = "ISAF-II")
      program = ::Program.find_by name: program_name
      return if program.nil?

      xlsx = Roo::Spreadsheet.open(file_path("indicator.xlsx"))
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        facility_code = page_name[/\((.*?)\)/, 1]
        facility = program.facilities.find_by(code: facility_code)

        upsert_indicators(rows, facility)
      end
    end

    private
      def self.upsert_indicators(rows, facility)
        return if facility.nil?

        rows[1..-1].each_with_index do |row, index|
          indicator_name = row["Scorecard Criterias"]
          next if indicator_name.blank?

          indicator = facility.indicators.find_or_initialize_by(name: indicator_name)
          update_params = {
            tag_attributes: { name: row["tag"] || indicator_name },
            hint: row["hint"]
          }

          indicator.update(update_params)

          upsert_languages_indicators(facility, indicator, row)
        end
      end

      def self.upsert_languages_indicators(facility, indicator, row)
        facility.program.languages.each do |language|
          audio = get_audio(language, row)

          next if audio.nil?

          lang_indi = indicator.languages_indicators.find_or_initialize_by(language_code: language.code)
          lang_indi.update(
            language_id: language.id,
            language_code: language.code,
            content: indicator.name,
            audio: Pathname.new(audio).open
          )
        end
      end
  end
end
