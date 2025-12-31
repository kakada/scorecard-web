# frozen_string_literal: true

require "rails_helper"

RSpec.describe CalculateVotingResultsWorker do
  describe "#perform" do
    let!(:scorecard) { create(:scorecard) }

    it "updates median for indicators based on their ratings" do
      indicator1 = create(:voting_indicator, scorecard: scorecard, median: nil)
      indicator2 = create(:voting_indicator, scorecard: scorecard, median: nil)

      create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 1)
      create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 3)
      create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 5)

      create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 2)
      create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 2)
      create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 4)

      described_class.new.perform(scorecard.id)

      expect(indicator1.reload.median_before_type_cast).to eq(3)
      expect(indicator2.reload.median_before_type_cast).to eq(2)
    end

    it "sets median to nil when there are no ratings" do
      indicator = create(:voting_indicator, scorecard: scorecard, median: 1)

      described_class.new.perform(scorecard.id)

      expect(indicator.reload.median).to be_nil
    end

    it "ignores nil scores when calculating median" do
      indicator = create(:voting_indicator, scorecard: scorecard, median: nil)

      create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: nil)
      create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: 1)
      create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: 3)

      described_class.new.perform(scorecard.id)

      expect(indicator.reload.median_before_type_cast).to eq(2)
    end
  end
end
