# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::IndicatorsController", type: :request do
  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:facility) { create(:facility, :with_indicators) }
    let!(:custom_indicator) {
      facility.indicators.create(name: "Custom", type: "Indicators::CustomIndicator")
    }
    let(:predefine_indicator) { facility.indicators.predefines.first }
    let(:json_response) { JSON.parse(response.body) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" }
      get "/api/v1/facilities/#{facility.id}/indicators", headers: headers
    }

    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(1) }
    it { expect(json_response.first["id"]).to eq(predefine_indicator.id) }
    it { expect(json_response.first["hint"]).to eq(predefine_indicator.hint) }
  end
end
