# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicVoteForm, type: :model do
  let(:program) { create(:program) }
  let(:user) { create(:user, program: program) }
  let(:facility) { create(:facility, program: program) }
  let(:scorecard) { create(:scorecard, program: program, facility: facility, creator: user, progress: :open_voting) }
  let(:indicator1) { create(:indicator, categorizable: facility) }
  let(:indicator2) { create(:indicator, categorizable: facility) }
  let(:voting_indicator1) { create(:voting_indicator, scorecard: scorecard, indicator: indicator1, display_order: 1) }
  let(:voting_indicator2) { create(:voting_indicator, scorecard: scorecard, indicator: indicator2, display_order: 2) }

  describe "#voting_indicators" do
    it "loads voting indicators from the scorecard" do
      voting_indicator1
      voting_indicator2
      
      form = PublicVoteForm.new(scorecard: scorecard)
      indicators = form.voting_indicators
      
      expect(indicators.count).to eq(2)
      expect(indicators.first).to eq(voting_indicator1)
      expect(indicators.last).to eq(voting_indicator2)
    end

    it "orders indicators by display_order" do
      voting_indicator2
      voting_indicator1
      
      form = PublicVoteForm.new(scorecard: scorecard)
      indicators = form.voting_indicators
      
      expect(indicators.first.display_order).to eq(1)
      expect(indicators.last.display_order).to eq(2)
    end

    it "includes the indicator association" do
      voting_indicator1
      
      form = PublicVoteForm.new(scorecard: scorecard)
      
      # This should not trigger an additional query
      expect {
        form.voting_indicators.first.indicator.name
      }.not_to exceed_query_limit(0)
    end

    it "returns empty array when scorecard is nil" do
      form = PublicVoteForm.new(scorecard: nil)
      expect(form.voting_indicators).to eq([])
    end
  end

  describe "validations" do
    let(:form) do
      PublicVoteForm.new(
        scorecard: scorecard,
        participant_age: 25,
        participant_gender: "female",
        ratings: ratings
      )
    end

    context "when all indicators are rated" do
      let(:ratings) do
        voting_indicator1
        voting_indicator2
        {
          voting_indicator1.uuid => 4,
          voting_indicator2.uuid => 5
        }
      end

      it "is valid" do
        expect(form).to be_valid
      end
    end

    context "when some indicators are missing ratings" do
      let(:ratings) do
        voting_indicator1
        voting_indicator2
        {
          voting_indicator1.uuid => 4
        }
      end

      it "is invalid" do
        expect(form).not_to be_valid
        expect(form.errors[:ratings]).to include("Please rate all indicators")
      end
    end

    context "when no ratings are provided" do
      let(:ratings) { nil }

      it "is invalid" do
        voting_indicator1
        voting_indicator2
        
        expect(form).not_to be_valid
        expect(form.errors[:ratings]).to include("Please rate all indicators")
      end
    end
  end
end
