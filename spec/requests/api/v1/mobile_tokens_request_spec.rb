# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::MobileTokensController", type: :request do
  describe "GET #index" do
    let!(:program) { create(:program) }
    let(:json_response) { JSON.parse(response.body) }

    context "new device_id" do
      let(:params) {
        { token: "abcd", device_id: "a1b2", device_type: "mobile", app_version: "1.0.1", program_id: program.id }
      }

      before {
        headers = { "ACCEPT" => "application/json" }
        put "/api/v1/mobile_tokens", params: { mobile_token: params }, headers: headers
      }

      it { expect(response.status).to eq(200) }
      it { expect(MobileToken.count).to eq(1) }
    end

    context "existing device_id" do
      let!(:mobile_token) { create(:mobile_token, token: "abcd", device_id: "a1b2", device_type: "mobile", app_version: "1.0.1", program_id: program.id) }
      let(:params) {
        { token: "abcdefgh", device_id: "a1b2", device_type: "mobile", app_version: "1.0.2", program_id: program.id }
      }

      before {
        headers = { "ACCEPT" => "application/json" }
        put "/api/v1/mobile_tokens", params: { mobile_token: params }, headers: headers
      }

      it { expect(response.status).to eq(200) }
      it { expect(MobileToken.count).to eq(1) }
      it { expect(mobile_token.reload.token).to eq("abcdefgh") }
    end
  end
end
