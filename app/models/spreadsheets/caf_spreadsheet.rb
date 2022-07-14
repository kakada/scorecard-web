# frozen_string_literal: true

class Spreadsheets::CafSpreadsheet < Spreadsheets::BaseSpreadsheet
  attr_reader :local_ngo

  def initialize(local_ngo)
    @local_ngo = local_ngo
  end

  def process(row)
    return if row["full_name"].blank?

    local_ngo.cafs.create(
      name: row["full_name"],
      sex: row["gender"].to_s.downcase,
      date_of_birth: row["date_of_birth"],
      tel: row["tel"],
      address: row["address"]
    )
  end
end
