# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicVoteForm, type: :model do
  let!(:user) { create(:user, :lngo) }
  let!(:facility) { create(:facility, :with_parent, :with_indicators) }
  let!(:indicator) { facility.indicators.first }
  let!(:scorecard) { create(:scorecard, facility: facility, program: user.program, local_ngo_id: user.local_ngo_id) }

  let!(:vi1) { create(:voting_indicator, scorecard_uuid: scorecard.id, indicatorable_id: indicator.id, indicatorable_type: "Indicators::PredefineIndicator", display_order: 1) }
  let!(:vi2) { create(:voting_indicator, scorecard_uuid: scorecard.id, indicatorable_id: indicator.id, indicatorable_type: "Indicators::PredefineIndicator", display_order: 2) }

  describe "validations" do
    it "is valid with age, gender and scores for all indicators" do
      form = described_class.new(
        scorecard: scorecard,
        params: {
          age: 20,
          gender: "male",
          scores: { vi1.uuid => 4, vi2.uuid => 3 }
        }
      )

      expect(form).to be_valid
    end

    it "requires age" do
      form = described_class.new(
        scorecard: scorecard,
        params: { gender: "female", scores: { vi1.uuid => 5, vi2.uuid => 4 } }
      )

      expect(form).not_to be_valid
      expect(form.errors[:age]).to be_present
    end

    it "requires gender" do
      form = described_class.new(
        scorecard: scorecard,
        params: { age: 25, scores: { vi1.uuid => 5, vi2.uuid => 4 } }
      )

      expect(form).not_to be_valid
      expect(form.errors[:gender]).to be_present
    end

    it "requires a score for each voting indicator" do
      form = described_class.new(
        scorecard: scorecard,
        params: { age: 25, gender: "male", scores: { vi1.uuid => 5 } }
      )

      expect(form).not_to be_valid
      expect(form.score_error?(vi2)).to be(true)
      expect(form.score_error_for(vi2)).to be_present
    end
  end

  describe "#save" do
    it "creates participant and ratings when valid" do
      form = described_class.new(
        scorecard: scorecard,
        params: {
          age: 18,
          gender: "female",
          disability: false,
          minority: true,
          poor_card: false,
          scores: { vi1.uuid => 4, vi2.uuid => 2 }
        }
      )

      expect(form.save).to be(true)
      expect(scorecard.participants.count).to eq(1)
      participant = scorecard.participants.first
      expect(participant.age).to eq(18)
      expect(participant.gender).to eq("female")
      expect(participant.youth).to be(true) # age between 15 and 30

      ratings = scorecard.ratings.where(participant_uuid: participant.uuid)
      expect(ratings.count).to eq(2)
      expect(ratings.find_by(voting_indicator_uuid: vi1.uuid).score).to eq(4)
      expect(ratings.find_by(voting_indicator_uuid: vi2.uuid).score).to eq(2)
    end

    it "returns false and does not persist when invalid" do
      form = described_class.new(
        scorecard: scorecard,
        params: { age: 25, gender: "male", scores: { vi1.uuid => 5 } }
      )

      expect(form.save).to be(false)
      expect(scorecard.participants.count).to eq(0)
      expect(scorecard.ratings.count).to eq(0)
    end
  end
end
