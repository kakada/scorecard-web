# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dashboards::VariableInterpreter do
  let(:program) { create(:program) }
  let(:data) { { "templating" => { "list" => list } } }

  describe "#interpret" do
    context "program_id variable" do
      let(:list) do
        [{
          "name" => "program_id",
          "definition" => "select * where program_id in (${program_id})",
          "query" => "select * where program_id in (${program_id})",
          "hide" => 0
        }]
      end

      it "substitutes the program_id placeholder in the definition and query" do
        described_class.new(program, data, "km").interpret

        expect(list.first["definition"]).to eq("select * where program_id in (#{program.id})")
        expect(list.first["query"]).to eq("select * where program_id in (#{program.id})")
      end

      it "hides the variable from the dashboard UI" do
        described_class.new(program, data, "km").interpret

        expect(list.first["hide"]).to eq(2)
      end
    end

    context "a variable with a known label translation" do
      let(:list) do
        [{ "name" => "province_id", "definition" => "", "query" => "", "hide" => 0, "label" => "Original" }]
      end

      it "translates the label to Khmer for the km locale" do
        described_class.new(program, data, "km").interpret

        expect(list.first["label"]).to eq("ខេត្ត")
      end

      it "translates the label to English for the en locale" do
        described_class.new(program, data, "en").interpret

        expect(list.first["label"]).to eq("Province")
      end
    end

    context "a variable without a known label translation" do
      let(:list) do
        [{ "name" => "age", "definition" => "", "query" => "", "hide" => 0, "label" => "Age" }]
      end

      it "leaves the label untouched" do
        described_class.new(program, data, "en").interpret

        expect(list.first["label"]).to eq("Age")
      end
    end

    context "the locale variable" do
      let(:list) do
        [{
          "name" => "locale",
          "definition" => "",
          "query" => "ខ្មែរ : km, English : en",
          "hide" => 0,
          "options" => [
            { "selected" => true, "text" => "ខ្មែរ", "value" => "km" },
            { "selected" => false, "text" => "English", "value" => "en" }
          ],
          "current" => { "selected" => true, "text" => "ខ្មែរ", "value" => "km" }
        }]
      end

      it "hides the variable and defaults it to the interpreted locale" do
        described_class.new(program, data, "en").interpret

        variable = list.first
        expect(variable["hide"]).to eq(2)
        expect(variable["current"]).to eq("selected" => true, "text" => "English", "value" => "en")
        expect(variable["options"]).to eq([
          { "selected" => false, "text" => "ខ្មែរ", "value" => "km" },
          { "selected" => true, "text" => "English", "value" => "en" }
        ])
      end

      it "defaults to km when interpreted for the km locale" do
        described_class.new(program, data, "km").interpret

        expect(list.first["current"]).to eq("selected" => true, "text" => "ខ្មែរ", "value" => "km")
      end
    end

    context "variable datasource" do
      let(:list) do
        [{
          "name" => "year",
          "definition" => "",
          "query" => "",
          "hide" => 0,
          "datasource" => { "type" => "postgres", "uid" => "some-uid" }
        }]
      end

      it "removes the datasource" do
        described_class.new(program, data, "km").interpret

        expect(list.first).not_to have_key("datasource")
      end
    end
  end
end
