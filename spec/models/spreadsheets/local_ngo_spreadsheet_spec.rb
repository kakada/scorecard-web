# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spreadsheets::LocalNgoSpreadsheet do
  describe "#process" do
    let(:program) { create(:program) }
    let(:local_ngo_spreadsheet) { Spreadsheets::LocalNgoSpreadsheet.new(program) }
    let(:row) { {  "name" => "LNGO1", "province_id" => "01", "district_id" => "0102", "commune_id" => "010201", "target_province_ids" => "01,02" } }

    context "new record" do
      it "creates a new local ngo" do
        expect { local_ngo_spreadsheet.process(row) }.to change { LocalNgo.count }.from(0).to(1)
      end
    end
  end
end
