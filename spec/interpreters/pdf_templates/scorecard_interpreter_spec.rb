# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfTemplates::ScorecardInterpreter do
  let(:program) { create(:program) }
  let(:scorecard) { create(:scorecard, program: program, year: 2024) }
  let(:interpreter) { described_class.new(scorecard) }

  describe "#conducted_location" do
    context "when scorecard has no dataset_id" do
      let(:scorecard_without_dataset) { instance_double("Scorecard", dataset: nil) }

      it "returns an empty string" do
        expect(described_class.new(scorecard_without_dataset).conducted_location).to eq("")
      end
    end

    context "when scorecard has dataset_id" do
      let(:category) { create(:category, name_en: "Primary School", name_km: "បឋមសិក្សា") }
      let(:dataset) { create(:dataset, category: category, name_en: "Srey Thmey", name_km: "ស្រែថ្មី") }
      let(:scorecard_with_dataset) { instance_double("Scorecard", dataset_id: dataset.id, dataset: dataset) }

      context "when locale is English" do
        before { I18n.locale = :en }

        it "returns 'dataset name' then 'category name'" do
          expect(described_class.new(scorecard_with_dataset).conducted_location).to eq("Srey Thmey Primary School")
        end
      end

      context "when locale is Khmer" do
        before { I18n.locale = :km }
        after { I18n.locale = :en }

        it "returns 'category name' then 'dataset name'" do
          expect(described_class.new(scorecard_with_dataset).conducted_location).to eq("បឋមសិក្សាស្រែថ្មី")
        end
      end
    end
  end

  describe "#conducted_year_ce" do
    context "when locale is English" do
      before { I18n.locale = :en }

      it "returns the year in CE format with English numerals" do
        expect(interpreter.conducted_year_ce).to eq("2024")
      end
    end

    context "when locale is Khmer" do
      before { I18n.locale = :km }
      after { I18n.locale = :en }

      it "returns the year in CE format with Khmer numerals" do
        expect(interpreter.conducted_year_ce).to eq("២០២៤")
      end
    end

    context "when scorecard year is nil" do
      before { scorecard.year = nil }

      it "returns an empty string" do
        expect(interpreter.conducted_year_ce).to eq("")
      end
    end
  end

  describe "#conducted_year_be" do
    context "when locale is English" do
      before { I18n.locale = :en }

      it "returns the year in BE format (CE + 543) with English numerals" do
        expect(interpreter.conducted_year_be).to eq("2567")
      end
    end

    context "when locale is Khmer" do
      before { I18n.locale = :km }
      after { I18n.locale = :en }

      it "returns the year in BE format (CE + 543) with Khmer numerals" do
        expect(interpreter.conducted_year_be).to eq("២៥៦៧")
      end
    end

    context "when scorecard year is 2021" do
      before { scorecard.year = 2021 }

      context "when locale is English" do
        before { I18n.locale = :en }

        it "returns 2564 with English numerals" do
          expect(interpreter.conducted_year_be).to eq("2564")
        end
      end

      context "when locale is Khmer" do
        before { I18n.locale = :km }
        after { I18n.locale = :en }

        it "returns ២៥៦៤ with Khmer numerals" do
          expect(interpreter.conducted_year_be).to eq("២៥៦៤")
        end
      end
    end

    context "when scorecard year is nil" do
      before { scorecard.year = nil }

      it "returns an empty string" do
        expect(interpreter.conducted_year_be).to eq("")
      end
    end
  end

  describe "#load" do
    it "returns conducted_year_ce when field is conducted_year_ce" do
      expect(interpreter.load("conducted_year_ce")).to eq("2024")
    end

    it "returns conducted_year_be when field is conducted_year_be" do
      expect(interpreter.load("conducted_year_be")).to eq("2567")
    end

    it "delegates to scorecard when field is not defined on interpreter" do
      expect(interpreter.load("year")).to eq(2024)
    end

    context "when locale is Khmer" do
      before { I18n.locale = :km }
      after { I18n.locale = :en }

      it "returns localized conducted_year_ce" do
        expect(interpreter.load("conducted_year_ce")).to eq("២០២៤")
      end

      it "returns localized conducted_year_be" do
        expect(interpreter.load("conducted_year_be")).to eq("២៥៦៧")
      end
    end
  end
end
