# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UserGuides", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /user_guides" do
    context "when user is system_admin" do
      let(:user) { create(:user, :system_admin) }

      it "returns http success" do
        sign_in user
        get "/user_guides"
        expect(response).to have_http_status(:success)
      end

      it "shows all guides" do
        sign_in user
        get "/user_guides"
        expect(response.body).to include("System Admin User Guide")
        expect(response.body).to include("Program Admin User Guide")
        expect(response.body).to include("Staff/Officer User Guide")
        expect(response.body).to include("Local NGO User Guide")
        expect(response.body).to include("DCSC Mobile App User Guide")
      end
    end

    context "when user is program_admin" do
      let(:program) { create(:program) }
      let(:user) { create(:user, :program_admin, program: program) }

      it "returns http success" do
        sign_in user
        get "/user_guides"
        expect(response).to have_http_status(:success)
      end

      it "shows admin, staff, lngo and mobile app guides" do
        sign_in user
        get "/user_guides"
        expect(response.body).to include("Program Admin User Guide")
        expect(response.body).to include("Staff/Officer User Guide")
        expect(response.body).to include("Local NGO User Guide")
        expect(response.body).to include("DCSC Mobile App User Guide")
        expect(response.body).not_to include("System Admin User Guide")
      end
    end

    context "when user is staff" do
      let(:program) { create(:program) }
      let(:user) { create(:user, :staff, program: program) }

      it "returns http success" do
        sign_in user
        get "/user_guides"
        expect(response).to have_http_status(:success)
      end

      it "shows staff, lngo and mobile app guides" do
        sign_in user
        get "/user_guides"
        expect(response.body).to include("Staff/Officer User Guide")
        expect(response.body).to include("Local NGO User Guide")
        expect(response.body).to include("DCSC Mobile App User Guide")
        expect(response.body).not_to include("System Admin User Guide")
        expect(response.body).not_to include("Program Admin User Guide")
      end
    end

    context "when user is lngo" do
      let(:program) { create(:program) }
      let(:local_ngo) { create(:local_ngo, program: program) }
      let(:user) { create(:user, :lngo, program: program, local_ngo: local_ngo) }

      it "returns http success" do
        sign_in user
        get "/user_guides"
        expect(response).to have_http_status(:success)
      end

      it "shows only lngo and mobile app guides" do
        sign_in user
        get "/user_guides"
        expect(response.body).to include("Local NGO User Guide")
        expect(response.body).to include("DCSC Mobile App User Guide")
        expect(response.body).not_to include("System Admin User Guide")
        expect(response.body).not_to include("Program Admin User Guide")
        expect(response.body).not_to include("Staff/Officer User Guide")
      end
    end

    context "when user is not authenticated" do
      it "redirects to sign in" do
        get "/user_guides"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
