# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfTemplates::ScorecardInterpreter do
  let(:program) { create(:program) }
  let(:scorecard) { create(:scorecard, program: program, year: 2024) }
  let(:interpreter) { described_class.new(scorecard) }

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
