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

    context "participant demographics normalization" do
      let!(:scorecard_online)  { create(:scorecard, running_mode: "online") }
      let!(:scorecard_offline) { create(:scorecard, running_mode: "offline") }

      it "merges computed demographics for online scorecards" do
        # 3 countable participants and 1 non-countable
        Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: true,  minority: true,  youth: true,  poor_card: false, countable: true)
        Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: false, minority: false, youth: true,  poor_card: true,  countable: true)
        Participant.create!(scorecard_uuid: scorecard_online.id, gender: "male",   disability: false, minority: false, youth: false, poor_card: false, countable: true)
        Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: true,  minority: true,  youth: true,  poor_card: true,  countable: false)

        # Provide conflicting values to ensure they get overridden
        params = { number_of_participant: 999, number_of_female: 999 }
        result = described_class.new(scorecard_online, params).call

        expect(result[:number_of_participant]).to eq(3)
        expect(result[:number_of_female]).to eq(2)
        expect(result[:number_of_disability]).to eq(1)
        expect(result[:number_of_ethnic_minority]).to eq(1)
        expect(result[:number_of_youth]).to eq(2)
        expect(result[:number_of_id_poor]).to eq(1)
      end

      it "does not override submitted demographics for offline scorecards" do
        params = {
          number_of_participant: 10,
          number_of_female: 5,
          number_of_disability: 2,
          number_of_ethnic_minority: 1,
          number_of_youth: 3,
          number_of_id_poor: 4
        }

        result = described_class.new(scorecard_offline, params).call

        expect(result).to include(params)
      end
    end
  end
end
