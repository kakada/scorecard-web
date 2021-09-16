# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ContactsController", type: :request do
  describe "GET #index" do
    let!(:program) { create(:program) }
    let!(:user) { create(:user, program: program) }

    context "with program" do
      let!(:contact) { create(:contact, program_id: program.id) }
      let(:json_response) { JSON.parse(response.body) }

      before {
        headers = { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" }
        get "/api/v1/contacts", headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response.status).to eq(200) }
      it { expect(json_response.length).to eq(1) }
    end

    context "without program" do
      it "returns project contact information" do
        get '/api/v1/contacts', headers: { Authorization: "Token #{user.authentication_token}" }

        expect(response.status).to eq 200
      end
    end
  end
end
