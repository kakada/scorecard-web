# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ScorecardsController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:scorecard) { create(:scorecard) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" }
      get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
    }

    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response.status).to eq(200) }
    it { expect(response.body).not_to be_nil }
  end

  describe "PUT #update" do
    let!(:user)       { create(:user) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3) }
    let(:json_response) { JSON.parse(response.body) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" }
      params = {
        number_of_caf: 3,
        number_of_participant: 15,
        number_of_female: 5,
      }

      put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
    }

    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response).to have_http_status(:ok) }
    it { expect(scorecard.reload.number_of_participant).to eq(15) }
  end
end
