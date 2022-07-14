# frozen_string_literal: true

class Spreadsheets::LocalNgoSpreadsheet < Spreadsheets::BaseSpreadsheet
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def process(row)
    program.local_ngos.create(
      name: row["name"],
      website_url: row["website_url"],
      province_id: row["province_id"],
      district_id: row["district_id"],
      commune_id: row["commune_id"],
      village_id: row["village_id"],
      target_province_ids: row["target_province_ids"]
    )
  end
end
