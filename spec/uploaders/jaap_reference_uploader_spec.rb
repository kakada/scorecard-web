# frozen_string_literal: true

require "rails_helper"

RSpec.describe JaapReferenceUploader do
  let(:jaap) { build(:jaap) }
  let(:uploader) { JaapReferenceUploader.new(jaap, :reference) }

  describe "extension_allowlist" do
    it "allows image files" do
      expect(uploader.extension_allowlist).to include("jpg", "jpeg", "png", "gif")
    end

    it "allows PDF files" do
      expect(uploader.extension_allowlist).to include("pdf")
    end

    it "allows Excel files" do
      expect(uploader.extension_allowlist).to include("xls", "xlsx")
    end

    it "does not allow other file types" do
      expect(uploader.extension_allowlist).not_to include("doc", "docx", "txt", "zip")
    end
  end

  describe "content_type_allowlist" do
    it "includes allowed content types" do
      allowlist = uploader.content_type_allowlist

      # Check for PDF
      expect(allowlist).to include("application/pdf")

      # Check for Excel
      expect(allowlist).to include("application/vnd.ms-excel")
      expect(allowlist).to include("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    end
  end

  describe "size_range" do
    it "limits file size to 5MB" do
      expect(uploader.size_range).to eq(0..5.megabytes)
    end
  end
end
