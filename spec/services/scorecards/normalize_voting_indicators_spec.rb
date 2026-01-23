# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::NormalizeVotingIndicators do
  describe "#call" do
    let!(:scorecard) { create(:scorecard) }
    let!(:indicator) { create(:indicator) }

    context "when no voting_indicators_attributes present" do
      it "returns params unchanged" do
        params = { some: "value" }
        result = described_class.new(scorecard, params).call
        expect(result).to eq(params)
      end
    end

    context "when attributes include indicator_uuid matching existing record" do
      let!(:existing) { create(:voting_indicator, scorecard: scorecard, indicator: indicator, indicatorable: indicator) }

      it "injects the existing id so it updates instead of creating" do
        params = {
          voting_indicators_attributes: [
            { indicator_uuid: indicator.uuid }
          ]
        }

        result = described_class.new(scorecard, params).call

        expect(result[:voting_indicators_attributes].first[:id]).to eq(existing.id)
      end
    end

    context "when attributes include indicator_uuid but no existing record" do
      it "does not set id" do
        params = {
          voting_indicators_attributes: [
            { indicator_uuid: indicator.uuid }
          ]
        }

        result = described_class.new(scorecard, params).call

        expect(result[:voting_indicators_attributes].first[:id]).to be_nil
      end
    end

    context "when attribute already has id" do
      it "does not override the existing id" do
        params = {
          voting_indicators_attributes: [
            { id: "preset-id", indicator_uuid: indicator.uuid }
          ]
        }

        result = described_class.new(scorecard, params).call

        expect(result[:voting_indicators_attributes].first[:id]).to eq("preset-id")
      end
    end

    context "when attribute has no indicator_uuid" do
      it "ignores that attribute" do
        params = {
          voting_indicators_attributes: [
            { foo: "bar" }
          ]
        }

        result = described_class.new(scorecard, params).call

        expect(result[:voting_indicators_attributes].first).to eq({ foo: "bar" })
      end
    end
  end
end
