# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ScorecardsController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:scorecard) { create(:scorecard) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => user.authentication_token }
      get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
    }

    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response.status).to eq(200) }
    it { expect(response.body).not_to be_nil }
  end
end
