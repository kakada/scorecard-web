# frozen_string_literal: true

class Spreadsheets::LocalNgoSpreadsheet
  attr_reader :program

  def initialize(program_uuid)
    @program = Program.find_by(uuid: program_uuid)
  end

  def import(sheet)
    rows = sheet.parse(headers: true)

    rows[1..-1].each do |row|
      process(row)
    end
  end

  def process(row)
    lngo = program.local_ngos.find_or_initialize_by(code: row["code"])
    lngo.update({
      name: row["name"],
      website_url: row["website_url"],
      province_id: row["province_id"],
      district_id: row["district_id"],
      commune_id: row["commune_id"],
      village_id: row["village_id"],
      target_province_ids: row["target_province_ids"]
    })
  end
end
