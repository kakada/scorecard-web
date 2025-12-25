# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PublicVotesController", type: :request do
  let!(:user) { create(:user, :lngo) }
  let!(:unit) { create(:facility, program: user.program) }
  let!(:facility) { create(:facility, :with_indicators, parent_id: unit.id, program: user.program) }
  let!(:indicator) { facility.indicators.first }
  let!(:scorecard) { create(:scorecard, facility: facility, program: user.program, local_ngo_id: user.local_ngo_id, progress: :open_voting) }

  describe "GET /scorecards/:uuid/vote (new)" do
    context "when voting is open" do
      it "returns 200" do
        get public_vote_path(scorecard.uuid)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when voting is closed" do
      before { scorecard.update!(progress: :close_voting) }

      it "returns 403" do
        get public_vote_path(scorecard.uuid)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /scorecards/:uuid/vote (create)" do
    let!(:vi1) { create(:voting_indicator, scorecard_uuid: scorecard.id, indicatorable_id: indicator.id, indicatorable_type: "Indicators::PredefineIndicator", display_order: 1) }
    let!(:vi2) { create(:voting_indicator, scorecard_uuid: scorecard.id, indicatorable_id: indicator.id, indicatorable_type: "Indicators::PredefineIndicator", display_order: 2) }

    context "with valid params" do
      let(:params) do
        {
          public_vote_form: {
            age: 25,
            gender: "male",
            disability: false,
            minority: false,
            poor_card: false,
            scores: {
              vi1.uuid => 4,
              vi2.uuid => 3
            }
          }
        }
      end

      it "creates participant and ratings, then redirects to thank_you" do
        expect {
          post public_vote_path(scorecard.uuid), params: params
        }.to change { scorecard.participants.count }.by(1)
         .and change { scorecard.ratings.count }.by(2)

        expect(vi1.reload.ratings.count).to eq(1)
        expect(vi2.reload.ratings.count).to eq(1)

        expect(response).to redirect_to(thank_you_scorecard_vote_url(scorecard.uuid))
      end
    end

    context "missing gender" do
      let(:params) do
        {
          public_vote_form: {
            age: 25,
            scores: { vi1.uuid => 4, vi2.uuid => 3 }
          }
        }
      end

      it "renders new with 422" do
        post public_vote_path(scorecard.uuid), params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(scorecard.participants.count).to eq(0)
        expect(scorecard.ratings.count).to eq(0)
      end
    end

    context "missing scores for one indicator" do
      let(:params) do
        {
          public_vote_form: {
            age: 25,
            gender: "female",
            scores: { vi1.uuid => 5 }
          }
        }
      end

      it "renders new with 422" do
        post public_vote_path(scorecard.uuid), params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(scorecard.participants.count).to eq(0)
        expect(scorecard.ratings.count).to eq(0)
      end
    end
  end

  describe "GET /scorecards/:uuid/vote/thank_you" do
    it "returns 200" do
      get thank_you_scorecard_vote_path(scorecard.uuid)
      expect(response).to have_http_status(:ok)
    end
  end
end
