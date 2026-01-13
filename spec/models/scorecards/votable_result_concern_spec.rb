# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::VotableResultConcern, type: :model do
  describe "#after_save: calculate_voting_results" do
    context "when status is close_voting" do
      let!(:scorecard) { create(:scorecard, progress: :open_voting) }
      let!(:scorecard_progress) { build(:scorecard_progress, scorecard: scorecard, status: :close_voting) }

      it "calculates voting results for all indicators" do
        indicator1 = create(:voting_indicator, scorecard: scorecard, median: nil)
        indicator2 = create(:voting_indicator, scorecard: scorecard, median: nil)

        create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 1)
        create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 3)
        create(:rating, voting_indicator_uuid: indicator1.uuid, scorecard_uuid: scorecard.uuid, score: 5)

        create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 2)
        create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 2)
        create(:rating, voting_indicator_uuid: indicator2.uuid, scorecard_uuid: scorecard.uuid, score: 4)

        scorecard_progress.save

        expect(indicator1.reload.median_before_type_cast).to eq(3)
        expect(indicator2.reload.median_before_type_cast).to eq(2)
      end

      it "sets median to nil when there are no ratings" do
        indicator = create(:voting_indicator, scorecard: scorecard, median: 1)

        scorecard_progress.save

        expect(indicator.reload.median).to be_nil
      end

      it "ignores nil scores when calculating median" do
        indicator = create(:voting_indicator, scorecard: scorecard, median: nil)

        create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: nil)
        create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: 1)
        create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: 3)

        scorecard_progress.save

        expect(indicator.reload.median_before_type_cast).to eq(2)
      end
    end

    context "when status is not close_voting" do
      let!(:scorecard) { create(:scorecard, progress: :running) }

      it "does not calculate voting results" do
        indicator = create(:voting_indicator, scorecard: scorecard, median: nil)

        create(:rating, voting_indicator_uuid: indicator.uuid, scorecard_uuid: scorecard.uuid, score: 5)

        create(:scorecard_progress, status: :open_voting, scorecard: scorecard)

        expect(indicator.reload.median).to be_nil
      end
    end
  end
end
