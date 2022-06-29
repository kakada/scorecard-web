class Spreadsheets::BaseSpreadsheet
  def import(file_path)
    return unless valid?(file_path)

    spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
      rows = sheet.parse(headers: true)
      rows[1..-1].each do |row|
        process(row)
      end
    end
  end

  private
    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end

    def valid?(file_path)
      file_path.present? && accepted_formats.include?(File.extname(file_path))
    end

    def accepted_formats
      [".xls", ".xlsx"]
    end
end
