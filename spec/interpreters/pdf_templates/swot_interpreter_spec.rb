# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfTemplates::SwotInterpreter do
  describe "#load" do
    let(:scorecard) { instance_double("Scorecard", online?: true, voting_indicators: []) }

    before do
      allow(Scorecards::ProposedCriteria).to receive(:new).with(scorecard)
        .and_return(instance_double("Scorecards::ProposedCriteria", criterias: []))
    end

    it "delegates to the requested field method" do
      interpreter = described_class.new(scorecard)

      expect(interpreter.load("result_table")).to eq(interpreter.result_table)
    end
  end

  describe "#result_table" do
    let(:indicator_uuid) { "indicator-uuid-1" }

    let(:indicator) { instance_double("Indicator", uuid: indicator_uuid, name: "Indicator A") }

    let(:strength_activity) { instance_double("IndicatorActivity", content: "Strength 1") }
    let(:weakness_activity) { instance_double("IndicatorActivity", content: "Weakness 1") }

    let(:suggested_activity_selected) do
      instance_double("IndicatorActivity", content: "Action 1", selected?: true)
    end

    let(:suggested_activity_unselected) do
      instance_double("IndicatorActivity", content: "Action 2", selected?: false)
    end

    let(:voting_indicator) do
      instance_double(
        "VotingIndicator",
        indicator: indicator,
        indicator_uuid: indicator_uuid,
        median: "good",
        strength_indicator_activities: [strength_activity],
        weakness_indicator_activities: [weakness_activity],
        suggested_indicator_activities: [suggested_activity_selected, suggested_activity_unselected]
      )
    end

    before do
      allow(I18n).to receive(:t) { |key| key.to_s }
    end

    context "when scorecard is online" do
      let(:scorecard) { instance_double("Scorecard", online?: true, voting_indicators: [voting_indicator]) }

      before do
        allow(Scorecards::ProposedCriteria).to receive(:new).with(scorecard)
          .and_return(instance_double("Scorecards::ProposedCriteria", criterias: []))
      end

      it "renders a table without shortcut note" do
        html = described_class.new(scorecard).result_table

        expect(html).to include("<table")
        expect(html).to include("<thead>")
        expect(html).to include("<tbody>")
        expect(html.scan(/<th\b/).length).to eq(6)
        expect(html).to include("Indicator A")

        # Suggested actions appear in two columns: suggested_action + priority_action (selected only)
        expect(html.scan("Action 1").length).to eq(2)
        expect(html.scan("Action 2").length).to eq(1)

        expect(html).not_to include("scorecard.note")
      end
    end

    context "when scorecard is offline" do
      let(:scorecard) { instance_double("Scorecard", online?: false, voting_indicators: [voting_indicator]) }

      let(:criterias) do
        [
          {
            "indicator" => indicator,
            "female_count" => 2,
            "youth_count" => 1
          }
        ]
      end

      before do
        allow(Scorecards::ProposedCriteria).to receive(:new).with(scorecard)
          .and_return(instance_double("Scorecards::ProposedCriteria", criterias: criterias))
      end

      it "renders participant profile counts and shortcut note" do
        html = described_class.new(scorecard).result_table

        expect(html).to include("<span class='participant-profile'>")
        expect(html).to include("scorecard.female_shortcut: 2")
        expect(html).to include("scorecard.youth_shortcut: 1")

        expect(html).to include("<div>")
        expect(html).to include("scorecard.note")
      end
    end
  end
end
