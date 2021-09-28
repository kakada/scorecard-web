# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramSpreadsheet do
  context "#import" do
    let(:program) { create(:program) }
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "local_ngo_and_caf.xlsx")) }
    let(:program_spreadsheet) { ProgramSpreadsheet.new(program) }

    it "receives import method for LocalNgoSpreadsheet" do
      expect_any_instance_of(Spreadsheets::LocalNgoSpreadsheet).to receive(:import).with(instance_of(Roo::Excelx))

      program_spreadsheet.import(file)
    end

    it "receives import method for CafSpreadsheet" do
      expect_any_instance_of(Spreadsheets::CafSpreadsheet).to receive(:import).with(instance_of(Roo::Excelx))

      program_spreadsheet.import(file)
    end
  end
end
