# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::MobileTokensController", type: :request do
  describe "GET #index" do
    let!(:program) { create(:program) }
    let(:json_response) { JSON.parse(response.body) }

    context "new token" do
      let(:params) {
        { id: "", token: "abcd", device_id: "a1b2", device_type: "mobile", app_version: "1.0.1", program_id: program.id }
      }

      before {
        headers = { "ACCEPT" => "application/json" }
        put "/api/v1/mobile_tokens", params: { mobile_token: params }, headers: headers
      }

      it { expect(response.status).to eq(200) }
    end
  end
end
