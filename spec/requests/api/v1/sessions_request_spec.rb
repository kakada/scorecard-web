# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SessionsController", type: :request do
  describe "POST #create" do
    let(:user) { create(:user, password: "password") }
    let(:json_response) { JSON.parse(response.body) }

    context "valid email and password" do
      before(:each) do
        post "/api/v1/sign_in", params: { user: { email: user.email, password: "password" } }
      end

      it { expect(response.status).to eq(200) }

      it "responses with user authentication_token" do
        expect(json_response["authentication_token"]).to eq(user.reload.authentication_token)
      end
    end

    context "account not confirm" do
      before(:each) do
        user.update(confirmed_at: nil)

        post "/api/v1/sign_in", params: { user: { email: user.email, password: "password" } }
      end

      it { expect(response.status).to eq(422) }

      it "responses error with message 'Your account is unprocessable'" do
        expect(json_response["error"]).to eq("Your account is unprocessable!")
      end
    end

    context "invalid password" do
      before(:each) do
        post "/api/v1/sign_in", params: { user: { email: user.email, password: "invalid_password" } }
      end

      it { expect(response.status).to eq(422) }

      it "responses error with message 'Invalid email or password'" do
        expect(json_response["error"]).to eq("Invalid email or password!")
      end
    end

    context "invalid email" do
      before(:each) do
        post "/api/v1/sign_in", params: { user: { email: "invalid@email.com", password: "password" } }
      end

      it { expect(response.status).to eq(422) }

      it "responses error with message 'Invalid email or password'" do
        expect(json_response["error"]).to eq("Invalid email or password!")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user, password: "password") }

    before(:each) do
      delete "/api/v1/sign_out", params: { authentication_token: user.authentication_token }
    end

    it { expect(response.status).to eq(204) }
  end
end
