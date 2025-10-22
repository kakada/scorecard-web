# frozen_string_literal: true

module Samples
  class RatingScale < Base
    def self.load(program_name = "ISAF-II")
      program = ::Program.find_by name: program_name
      return if program.nil?

      xlsx = Roo::Spreadsheet.open(file_path("indicator.xlsx"))
      xlsx.each_with_pagename do |page_name, sheet|
        next unless page_name == "Rating"

        rows = sheet.parse(headers: true)
        upsert_rating_scales(program, rows)
      end
    end

    private
      def self.upsert_rating_scales(program, rows)
        rows[1..-1].each_with_index do |row, index|
          rating = ::RatingScale.defaults.select { |rs| rs[:value] == row["No"].to_i.to_s }[0]

          next unless rating.present?

          rating_scale = program.rating_scales.find_or_initialize_by(code: rating[:code])
          rating_scale.update(
            value: rating[:value],
            name: row["Scorecard Criterias"]
          )

          upsert_language_rating_scales(rating_scale, row)
        end
      end

      def self.upsert_language_rating_scales(rating_scale, row)
        rating_scale.program.languages.each do |language|
          audio = get_audio(language, row)

          next if audio.nil?

          lang_rating_scale = rating_scale.language_rating_scales.find_or_initialize_by(language_code: language.code)
          lang_rating_scale.update(
            language_id: language.id,
            language_code: language.code,
            content: "#{rating_scale.name} (#{language.code})",
            audio: Pathname.new(audio).open
          )
        end
      end
  end
end
