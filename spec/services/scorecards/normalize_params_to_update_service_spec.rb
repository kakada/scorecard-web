# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::NormalizeParamsToUpdateService do
  describe "#call" do
    let!(:indicator) { create(:indicator) }

    context "voting indicators normalization" do
      let!(:scorecard) { create(:scorecard) }

      it "injects id for existing voting indicator and avoids duplicates" do
        existing = create(:voting_indicator, scorecard: scorecard, indicator: indicator, indicatorable: indicator)

        original = {
          voting_indicators_attributes: [
            { indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, display_order: 1 }
          ]
        }

        params = original.deep_dup
        result = described_class.new(scorecard, params).call

        vi = result[:voting_indicators_attributes].first
        expect(vi[:id]).to eq(existing.id)

        # original input is not mutated
        expect(original[:voting_indicators_attributes].first[:id]).to be_nil
      end

      it "preserves entries with preset id" do
        preset_id = "vi-123"
        params = {
          voting_indicators_attributes: [
            { id: preset_id, indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, display_order: 1 }
          ]
        }

        result = described_class.new(scorecard, params).call
        expect(result[:voting_indicators_attributes].first[:id]).to eq(preset_id)
      end

      it "keeps entries lacking indicator_uuid unchanged" do
        params = { voting_indicators_attributes: [ { scorecard_uuid: scorecard.uuid, display_order: 1 } ] }
        result = described_class.new(scorecard, params).call
        expect(result[:voting_indicators_attributes].first).to eq({ scorecard_uuid: scorecard.uuid, display_order: 1 })
      end

      it "returns params unchanged when no voting_indicators_attributes" do
        params = { some: "value" }
        result = described_class.new(scorecard, params).call
        expect(result[:some]).to eq("value")
      end
    end
  end
end
