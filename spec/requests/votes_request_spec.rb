# frozen_string_literal: true

require "rails_helper"

RSpec.describe "VotesController", type: :request do
  let!(:user) { create(:user, :lngo) }
  let!(:unit) { create(:facility, program: user.program) }
  let!(:facility) { create(:facility, :with_indicators, parent_id: unit.id, program: user.program) }
  let!(:indicator) { facility.indicators.first }
  let!(:scorecard) { create(:scorecard, facility: facility, program: user.program, local_ngo_id: user.local_ngo_id, progress: :open_voting) }

  describe "GET /scorecards/:token/votes (index)" do
    it "redirects to new action" do
      get scorecard_votes_path(scorecard.token)
      expect(response).to redirect_to(new_scorecard_vote_path(scorecard.token))
    end
  end

  describe "GET /scorecards/:token/votes/new (new)" do
    context "when voting is open" do
      it "returns 200" do
        get new_scorecard_vote_path(scorecard.token)
        expect(response).to have_http_status(:ok)
      end

      it "sets Open Graph meta tags" do
        get new_scorecard_vote_path(scorecard.token)

        # Check that response body contains OG meta tags
        expect(response.body).to include("og:title")
        expect(response.body).to include("og:description")
        expect(response.body).to include("og:url")
        expect(response.body).to include("og:type")
      end

      context "when scorecard has QR code" do
        before do
          # generate QR code for the scorecard
          scorecard.generate_qr_code
        end

        it "includes og:image meta tag with QR code URL" do
          get new_scorecard_vote_path(scorecard.token)
          expect(response.body).to include("og:image")
        end
      end
    end

    context "when voting is closed" do
      before { scorecard.update!(progress: :close_voting) }

      it "returns 403" do
        get new_scorecard_vote_path(scorecard.token)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /scorecards/:token/votes (create)" do
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

      it "creates participant and ratings, then redirects to show" do
        expect {
          post scorecard_votes_path(scorecard.token), params: params
        }.to change { scorecard.participants.count }.by(1)
         .and change { scorecard.ratings.count }.by(2)

        expect(vi1.reload.ratings.count).to eq(1)
        expect(vi2.reload.ratings.count).to eq(1)

        expect(response).to redirect_to(scorecard_vote_url(scorecard.token, "thank-you"))
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
        post scorecard_votes_path(scorecard.token), params: params
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
        post scorecard_votes_path(scorecard.token), params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(scorecard.participants.count).to eq(0)
        expect(scorecard.ratings.count).to eq(0)
      end
    end
  end

  describe "GET /scorecards/:token/votes/:id (show)" do
    it "returns 200" do
      get scorecard_vote_path(scorecard.token, "thank-you")
      expect(response).to have_http_status(:ok)
    end
  end
end
