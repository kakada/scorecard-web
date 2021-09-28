# frozen_string_literal: true

class ProgramSpreadsheet
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def import(file_path)
    spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
      get(sheet_name).import(sheet)
    rescue
      Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
    end
  end

  private
    def get(sheet_name)
      "Spreadsheets::#{sheet_name.camelcase}Spreadsheet".constantize.new(program.uuid)
    end

    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end
end
