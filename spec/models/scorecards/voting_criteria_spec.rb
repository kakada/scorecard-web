# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::VotingCriteria, type: :model do
  describe "#criterias" do
    let!(:scorecard) { create(:scorecard) }

    let!(:female)    { create(:participant, gender: "female", poor_card: true, youth: true) }
    let!(:male)      { create(:participant, gender: "male", disability: true, youth: true) }
    let!(:other)     { create(:participant, gender: "other", minority: true, youth: true) }

    let!(:indicator1) { create(:indicator) }
    let!(:indicator2) { create(:indicator) }

    let!(:voting_indicator1) { create(:voting_indicator, scorecard: scorecard, indicatorable: indicator1) }
    let!(:voting_indicator2) { create(:voting_indicator, scorecard: scorecard, indicatorable: indicator2) }

    let(:criterias) { Scorecards::VotingCriteria.new(scorecard).criterias }
    let(:criteria1) { criterias.select { |c| c["indicatorable_id"] == indicator1.id }[0] }
    let(:criteria2) { criterias.select { |c| c["indicatorable_id"] == indicator2.id }[0] }

    before do
      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator1.uuid, participant_uuid: female.uuid, score: 1)
      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator1.uuid, participant_uuid: male.uuid, score: 3)
      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator1.uuid, participant_uuid: other.uuid, score: 2)

      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator2.uuid, participant_uuid: female.uuid, score: 5)
      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator2.uuid, participant_uuid: male.uuid, score: 3)
      create(:rating, scorecard: scorecard, voting_indicator_uuid: voting_indicator2.uuid, participant_uuid: other.uuid, score: 4)
    end

    it "returns criterias length with 2" do
      expect(criterias.length).to eq(2)
    end

    describe "criteria1" do
      it { expect(criteria1["very_bad_count"]).to eq(1) }
      it { expect(criteria1["bad_count"]).to eq(1) }
      it { expect(criteria1["acceptable_count"]).to eq(1) }
      it { expect(criteria1["good_count"]).to eq(0) }
      it { expect(criteria1["very_good_count"]).to eq(0) }
    end

    describe "criteria2" do
      it { expect(criteria2["very_bad_count"]).to eq(0) }
      it { expect(criteria2["bad_count"]).to eq(0) }
      it { expect(criteria2["acceptable_count"]).to eq(1) }
      it { expect(criteria2["good_count"]).to eq(1) }
      it { expect(criteria2["very_good_count"]).to eq(1) }
    end
  end
end
