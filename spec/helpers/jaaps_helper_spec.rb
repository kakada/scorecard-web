# frozen_string_literal: true

require "rails_helper"

RSpec.describe JaapsHelper, type: :helper do
  describe "#file_type_icon" do
    it "returns PDF icon for pdf files" do
      expect(helper.file_type_icon("document.pdf")).to eq("fas fa-file-pdf text-danger")
    end

    it "returns Excel icon for xls files" do
      expect(helper.file_type_icon("spreadsheet.xls")).to eq("fas fa-file-excel text-success")
    end

    it "returns Excel icon for xlsx files" do
      expect(helper.file_type_icon("spreadsheet.xlsx")).to eq("fas fa-file-excel text-success")
    end

    it "returns image icon for jpg files" do
      expect(helper.file_type_icon("photo.jpg")).to eq("fas fa-file-image text-primary")
    end

    it "returns image icon for jpeg files" do
      expect(helper.file_type_icon("photo.jpeg")).to eq("fas fa-file-image text-primary")
    end

    it "returns image icon for png files" do
      expect(helper.file_type_icon("photo.png")).to eq("fas fa-file-image text-primary")
    end

    it "returns image icon for gif files" do
      expect(helper.file_type_icon("animation.gif")).to eq("fas fa-file-image text-primary")
    end

    it "returns default icon for unknown file types" do
      expect(helper.file_type_icon("file.txt")).to eq("fas fa-file")
    end

    it "returns default icon for blank filename" do
      expect(helper.file_type_icon("")).to eq("fas fa-file")
      expect(helper.file_type_icon(nil)).to eq("fas fa-file")
    end
  end
end
