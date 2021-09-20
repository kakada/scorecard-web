# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spreadsheets::PrimarySchoolSpreadsheet do
  describe "#process" do
    let!(:ps_spreadsheet) { Spreadsheets::PrimarySchoolSpreadsheet.new }

    context "row with full info" do
      let(:row) {{ "Province" => "Koh Kong", "District" => "Botum Sakor", "Commune" => "Andoung Tuek", "commune_code" => "090101", "school_code" => "090101_1", "school_name_en" => "Andaung Teuk", "school_name_km" => "អណ្តូងទឹក" }}

      it "creates a new valid record" do
        expect { ps_spreadsheet.process(row) }.to change { PrimarySchool.count }.from(0).to(1)
      end

      it "create a record with name_en is Andaung Teuk" do
        ps_spreadsheet.process(row)

        expect(PrimarySchool.last.name_en).to eq("Andaung Teuk")
      end
    end

    context "row with blank Province, District, Commune but has commune_code" do
      let(:row) {{ "Province" => "", "District" => "", "Commune" => "", "commune_code" => "090101", "school_code" => "090101_1", "school_name_en" => "Andaung Teuk", "school_name_km" => "អណ្តូងទឹក" }}

      it "creates a new valid record" do
        expect { ps_spreadsheet.process(row) }.to change { PrimarySchool.count }.from(0).to(1)
      end

      it "create a record with name_en is Andaung Teuk" do
        ps_spreadsheet.process(row)

        expect(PrimarySchool.last.name_en).to eq("Andaung Teuk")
      end
    end

    context "row with school_code" do
      let(:row) {{ "commune_code" => "090101", "school_code" => "090101_1", "school_name_en" => "Andaung Teuk", "school_name_km" => "អណ្តូងទឹក" }}

      it "creates a new valid record" do
        expect { ps_spreadsheet.process(row) }.to change { PrimarySchool.count }.from(0).to(1)
      end

      it "create a record with name_en is Andaung Teuk" do
        ps_spreadsheet.process(row)

        expect(PrimarySchool.last.name_en).to eq("Andaung Teuk")
      end
    end

    context "row without school_code" do
      let(:row) {{ "commune_code" => "090101", "school_code" => "", "school_name_en" => "Andaung Teuk", "school_name_km" => "អណ្តូងទឹក" }}

      it "creates a new valid record" do
        expect { ps_spreadsheet.process(row) }.to change { PrimarySchool.count }.from(0).to(1)
      end

      it "create a record with school_code is 090101_1" do
        ps_spreadsheet.process(row)

        expect(PrimarySchool.last.code).to eq("090101_1")
      end
    end

    context "row without commune_code" do
      let(:row) {{ "commune_code" => "", "school_code" => "", "school_name_en" => "Andaung Teuk", "school_name_km" => "អណ្តូងទឹក" }}

      it "doesn't create a record" do
        expect { ps_spreadsheet.process(row) }.to_not change(PrimarySchool, :count)
      end
    end

    context "existing record" do
      let!(:ps) { create(:primary_school, province_id: "09", district_id: "0901", commune_id: "090101", code: "090101_1", name_en: "Andaung Teuk", name_km: "អណ្តូងទឹក") }
      let(:row) {{ "commune_code" => "090101", "school_code" => "090101_1", "school_name_en" => "Andaung Teuk 1", "school_name_km" => "អណ្តូងទឹក 1" }}

      it "updates the primary_school" do
        ps_spreadsheet.process(row)

        expect(ps.reload.name_en).to eq("Andaung Teuk 1")
      end
    end
  end
end
