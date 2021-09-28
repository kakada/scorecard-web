# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spreadsheets::CafSpreadsheet do
  describe "#process" do
    let!(:program) { create(:program) }
    let!(:lngo)    { create(:local_ngo, code: "lngo0001", program: program) }
    let(:caf_spreadsheet) { Spreadsheets::CafSpreadsheet.new(program.uuid) }
    let(:row)      { { "local_ngo_code" => "lngo0001", "full_name" => "Sokra", "gender" => "female", "date_of_birth" => "1976-10-28", tel: "", "address" => "ផ្ទះលេខ71 ផ្លូវលេខ300 សង្កាត់បឹងកក់ទី ២ ខណ្ឌទួលគោក រាជធានីភ្នំពេញ" } }

    it "add a new caf to the local ngo" do
      expect { caf_spreadsheet.process(row, lngo) }.to change { lngo.cafs.count }.from(0).to(1)
    end
  end
end
