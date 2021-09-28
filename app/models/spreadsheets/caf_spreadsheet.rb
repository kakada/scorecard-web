# frozen_string_literal: true

class Spreadsheets::CafSpreadsheet
  attr_reader :program

  def initialize(program_uuid)
    @program = Program.find_by(uuid: program_uuid)
  end

  def import(sheet)
    rows = sheet.parse(headers: true)
    lngo = nil

    rows[1..-1].each do |row|
      lngo = program.local_ngos.find_by(code: row["local_ngo_code"]) if row["local_ngo_code"].present?
      process(row, lngo)
    end
  end

  def process(row, lngo)
    return if lngo.nil? || row["full_name"].blank?

    lngo.cafs.create({
      name: row["full_name"],
      sex: row["gender"].to_s.downcase,
      date_of_birth: row["date_of_birth"],
      tel: row["tel"],
      address: row["address"]
    })
  end
end
