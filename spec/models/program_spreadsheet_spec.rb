# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramSpreadsheet do
  describe "#import" do
    let(:program) { create(:program) }
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "local_ngo_and_caf.xlsx")) }
    let(:program_spreadsheet) { ProgramSpreadsheet.new(program.id) }

    context "no file" do
      it "returns nil" do
        expect(program_spreadsheet.import(nil)).to be_nil
      end
    end

    context "wrong file extension" do
      let(:wrong_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "reference_image.png")) }

      it "returns nil" do
        expect(program_spreadsheet.import(wrong_file)).to be_nil
      end
    end
  end
end
