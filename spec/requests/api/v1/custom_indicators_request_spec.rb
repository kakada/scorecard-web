# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::CustomIndicatorsController", type: :request do
  describe "POST #create" do
    let!(:user)       { create(:user) }
    let!(:scorecard)  { create(:scorecard) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { name: "Staff not commig on time", tag_attributes: { name: "timing" }, audio: "" } }

    context "success" do
      before {
        post "/api/v1/scorecards/#{scorecard.uuid}/custom_indicators", params: { custom_indicator: params.to_json }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:created) }
      it { expect(scorecard.custom_indicators.length).to eq(1) }
    end

    context "scorecard is locked!" do
      before { scorecard.lock_access! }

      it "raises error" do
        expect {
          post "/api/v1/scorecards/#{scorecard.uuid}/custom_indicators", params: { custom_indicator: params.to_json }, headers: headers
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
