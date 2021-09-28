# frozen_string_literal: true

require "rails_helper"

class Api::V2::BaseController < Api::V2::ApiController; end

RSpec.describe "Api::V2::ApiController", type: :controller do
  controller(Api::V2::BaseController) do
    def index
      render json: {}, status: 200
    end
  end

  describe "#authenticate_with_token!" do
    let(:user) { create(:user) }
    let(:json_response) { JSON.parse(response.body) }

    before :each do
      request.env["HTTP_ACCEPT"] = "application/json"
    end

    context "when no user" do
      it "returns 401" do
        get :index
        expect(response.status).to eq(401)
      end
    end

    context "when wrong token" do
      it "returns 401" do
        request.headers["Authorization"] = "Token #{SecureRandom.hex}"
        get :index
        expect(response.status).to eq(401)
      end
    end

    context "when user is locked" do
      before(:each) do
        user.lock_access!(send_instructions: false)
        request.headers["Authorization"] = "Token #{user.authentication_token}"
        get :index
      end

      it { expect(response.status).to eq(401) }
    end

    context "when valid user" do
      before(:each) do
        request.headers["Authorization"] = "Token #{user.authentication_token}"
        get :index
      end

      it { expect(response.status).to eq(200) }
    end
  end
end
