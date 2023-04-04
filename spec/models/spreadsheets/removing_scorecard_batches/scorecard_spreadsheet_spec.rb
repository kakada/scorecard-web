# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spreadsheets::RemovingScorecardBatches::ScorecardSpreadsheet do
  describe "#process" do
    let!(:lngo) { create(:local_ngo, code: "lngo11") }
    let!(:scorecard) { create(:scorecard, uuid: "123456", local_ngo: lngo, scorecard_type: "self_assessment", program: lngo.program) }
    let!(:scorecard_types) { scorecard.program.create_program_scorecard_types }
    let(:spreadsheed) { Spreadsheets::RemovingScorecardBatches::ScorecardSpreadsheet.new(scorecard.program, row) }

    context "matching lngo, scorecard code, and scorecard type" do
      let(:row)  { { "code" => scorecard.uuid, "local_ngo_code" => "lngo11", "scorecard_type_en" => "self_assessment" } }
      let!(:obj)  { spreadsheed.process }

      it "returns struct object with valid status" do
        expect(obj.valid?).to be_truthy
      end
    end

    context "invalid scorecard" do
      let(:row)  { { "code" => scorecard.uuid, "local_ngo_code" => "lngo", "scorecard_type_en" => "self_assessment" } }
      let!(:obj)  { spreadsheed.process }

      it "returns struct object with invalid status" do
        expect(obj.valid?).to be_falsey
      end
    end
  end
end
