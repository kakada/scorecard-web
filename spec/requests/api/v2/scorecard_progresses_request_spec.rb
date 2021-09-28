# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V2::ScorecardProgressesController", type: :request do
  describe "POST #create" do
    let!(:user)      { create(:user) }
    let!(:scorecard) { create(:scorecard) }
    let(:headers)    { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)     { { scorecard_uuid: scorecard.uuid, status: "downloaded", device_id: "124" } }

    before {
      post "/api/v2/scorecard_progresses", params: { scorecard_progress: params }, headers: headers
    }

    it { expect(response.status).to eq(200) }
    it { expect(scorecard.scorecard_progresses.length).to eq(1) }
  end
end
