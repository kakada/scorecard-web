class Spreadsheets::BaseSpreadsheet
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
