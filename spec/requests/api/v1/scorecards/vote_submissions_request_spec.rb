# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Scorecards::VoteSubmissionsController", type: :request do
  describe "GET #index" do
    let!(:user) { create(:user, :lngo) }
    let!(:facility) { create(:facility, :with_parent, :with_indicators) }
    let!(:scorecard) { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    let!(:participant_one) do
      create(:participant,
        scorecard: scorecard,
        age: 25,
        gender: "male",
        disability: false,
        minority: false,
        poor_card: false,
        device_submission_token: "device-token-1"
      )
    end
    let!(:participant_two) do
      create(:participant,
        scorecard: scorecard,
        age: 25,
        gender: "male",
        disability: false,
        minority: false,
        poor_card: false,
        device_submission_token: "device-token-1"
      )
    end
    let!(:voting_indicator) do
      create(:voting_indicator,
        scorecard_uuid: scorecard.id,
        indicatorable_id: facility.indicators.first.id,
        indicatorable_type: "Indicator",
        display_order: 1
      )
    end

    before do
      create(:rating, scorecard: scorecard, participant_uuid: participant_one.uuid, voting_indicator_uuid: voting_indicator.uuid, score: 4)
      create(:rating, scorecard: scorecard, participant_uuid: participant_two.uuid, voting_indicator_uuid: voting_indicator.uuid, score: 5)
      get "/api/v1/scorecards/#{scorecard.uuid}/vote_submissions", headers: headers
    end

    it { expect(response).to have_http_status(:ok) }

    it "returns submitted votes with duplicate flags and device tokens" do
      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq(2)
      expect(json_response.map { |submission| submission["device_submission_token"] }).to all(eq("device-token-1"))
      expect(json_response.first["ratings"]).to include(
        a_hash_including(
          "voting_indicator_uuid" => voting_indicator.uuid
        )
      )
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user, :lngo) }
    let!(:facility) { create(:facility, :with_parent, :with_indicators) }
    let!(:scorecard) { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let!(:participant) { create(:participant, scorecard: scorecard) }
    let!(:rating) { create(:rating, scorecard: scorecard, participant_uuid: participant.uuid) }

    it "deletes the participant submission and related ratings" do
      expect {
        delete "/api/v1/scorecards/#{scorecard.uuid}/vote_submissions/#{participant.uuid}", headers: headers
      }.to change { scorecard.reload.participants.count }.by(-1)
       .and change { scorecard.reload.ratings.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
