# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V2::CustomIndicatorsController", type: :request do
  describe "POST #create" do
    let!(:user)       { create(:user) }
    let!(:scorecard)  { create(:scorecard, program: user.program) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { name: "Staff not commig on time", tag_attributes: { name: "timing" }, audio: "" } }

    context "success" do
      before {
        post "/api/v2/scorecards/#{scorecard.uuid}/custom_indicators", params: { custom_indicator: params.to_json }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:created) }
      it { expect(scorecard.custom_indicators.length).to eq(1) }
    end

    context "scorecard is locked!" do
      before {
        scorecard.lock_access!
        post "/api/v2/scorecards/#{scorecard.uuid}/custom_indicators", params: { custom_indicator: params.to_json }, headers: headers
      }

      it "return 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end

    context "scorecard is not found" do
      before {
        post "/api/v2/scorecards/#{scorecard.uuid}abc/custom_indicators", params: { custom_indicator: params.to_json }, headers: headers
      }

      it "return 404" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(404)
      end
    end

    context "params tag no name" do
      let(:params_no_tag) { { name: "Staff behaviour", tag_attributes: { name: "" }, audio: "" } }

      before {
        post "/api/v2/scorecards/#{scorecard.uuid}/custom_indicators", params: { custom_indicator: params_no_tag.to_json }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:created) }
      it { expect(scorecard.custom_indicators.length).to eq(1) }
    end
  end
end
