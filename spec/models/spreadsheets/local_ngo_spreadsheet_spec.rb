# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spreadsheets::LocalNgoSpreadsheet do
  describe "#process" do
    let(:program) { create(:program) }
    let(:local_ngo_spreadsheet) { Spreadsheets::LocalNgoSpreadsheet.new(program.uuid) }
    let(:row) { { "code" => "lngo0001", "name" => "LNGO1", "province_id" => "01", "district_id" => "0102", "commune_id" => "010201", "target_province_ids" => "01,02" } }

    context "new record" do
      it "creates a new local ngo" do
        expect { local_ngo_spreadsheet.process(row) }.to change { LocalNgo.count }.from(0).to(1)
      end
    end

    context "existing record" do
      let!(:local_ngo) { create(:local_ngo, code: "lngo0001", name: "Lorem", program: program) }

      it "updates the local ngo" do
        local_ngo_spreadsheet.process(row)

        expect(local_ngo.reload.name).to eq("LNGO1")
      end
    end
  end
end
