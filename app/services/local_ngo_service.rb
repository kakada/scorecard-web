# frozen_string_literal: true

class LocalNgoService
  attr_reader :program

  def initialize(program_id)
    @program = Program.find(program_id)
  end

  def import(file)
    xlsx = Roo::Spreadsheet.open(file)
    xlsx.each_with_pagename do |page_name, sheet|
      import_local_ngos(sheet) if page_name == "local_ngos"
      import_cafs(sheet) if page_name == "cafs"
    end
  end

  private
    def import_local_ngos(sheet)
      rows = sheet.parse(headers: true)
      rows[1..-1].each do |row|
        lngo = program.local_ngos.find_or_initialize_by(code: row["code"])
        lngo.update({
          name: row["name"],
          province_id: row["province_id"],
          district_id: row["district_id"],
          commune_id: row["commune_id"],
          village_id: row["village_id"],
          target_province_ids: row["target_province_ids"]
        })
      end
    end

    def import_cafs(sheet)
      rows = sheet.parse(headers: true)
      lngo = nil

      rows[1..-1].each do |row|
        lngo = program.local_ngos.find_by(code: row["local_ngo_code"]) if row["local_ngo_code"].present?
        create_caf(lngo, row)
      end
    end

    def create_caf(lngo, row)
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
