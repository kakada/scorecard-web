# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ScorecardReferencesController", type: :request do
  describe "POST #create" do
    let!(:user)       { create(:user) }
    let!(:scorecard)  { create(:scorecard, program: user.program) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { uuid: "123", kind: 'swot_result' } }

    context "success" do
      before {
        post "/api/v1/scorecards/#{scorecard.uuid}/scorecard_references", params: { scorecard_reference: params.to_json, attachment: file_fixture("reference_image.png") }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:created) }
      it { expect(scorecard.reload.scorecard_references.length).to eq(1) }
    end

    context "scorecard is locked!" do
      before {
        scorecard.lock_access!
        post "/api/v1/scorecards/#{scorecard.uuid}/scorecard_references", params: { scorecard_reference: params.to_json }, headers: headers
      }

      it "return 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end

    context "scorecard is not found" do
      before {
        post "/api/v1/scorecards/#{scorecard.uuid}abc/scorecard_references", params: { scorecard_reference: params.to_json }, headers: headers
      }

      it "return 404" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(404)
      end
    end
  end
end
