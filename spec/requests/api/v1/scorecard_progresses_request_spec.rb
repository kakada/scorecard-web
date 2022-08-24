# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ScorecardProgressesController", type: :request do
  describe "POST #create" do
    let!(:user)      { create(:user, :lngo) }
    let!(:scorecard) { create(:scorecard, program_id: user.program_id, local_ngo_id: user.local_ngo_id) }
    let(:headers)    { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)     { { scorecard_uuid: scorecard.uuid, status: "downloaded", device_id: "124" } }

    context "scorecard is not submitted" do
      before {
        post "/api/v1/scorecard_progresses", params: { scorecard_progress: params }, headers: headers
      }

      it { expect(response.status).to eq(200) }
      it { expect(scorecard.scorecard_progresses.length).to eq(1) }
      it { expect(scorecard.scorecard_progresses.first.user_id).to eq(user.id) }
    end

    context "scorecard is submitted" do
      let!(:scorecard) { create(:scorecard, :submitted, program_id: user.program_id, local_ngo_id: user.local_ngo_id) }

      before {
        post "/api/v1/scorecard_progresses", params: { scorecard_progress: params }, headers: headers
      }

      it { expect(response.status).to eq(403) }
    end
  end
end
