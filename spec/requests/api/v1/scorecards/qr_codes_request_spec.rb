# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Scorecards::QrCodesController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user, :lngo) }
    let!(:scorecard) { create(:scorecard, program_id: user.program_id, local_ngo_id: user.local_ngo_id) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "when QR code exists" do
      before do
        # Generate QR code
        scorecard.generate_qr_code
        get "/api/v1/scorecards/#{scorecard.uuid}/qr_code", headers: headers
      end

      it { expect(response.status).to eq(200) }

      it "returns QR code URL and voting URL" do
        json_response = JSON.parse(response.body)

        expect(json_response["qr_code_url"]).to be_present
        expect(json_response["voting_url"]).to eq("http://localhost:3000/scorecards/#{scorecard.token}/votes/new")
      end
    end

    context "when QR code does not exist" do
      before do
        get "/api/v1/scorecards/#{scorecard.uuid}/qr_code", headers: headers
      end

      it { expect(response.status).to eq(404) }

      it "returns an error message" do
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("QR code not available")
      end
    end

    context "different local ngo" do
      let!(:scorecard) { create(:scorecard) }

      before do
        get "/api/v1/scorecards/#{scorecard.uuid}/qr_code", headers: headers
      end

      it "returns 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end
  end
end
