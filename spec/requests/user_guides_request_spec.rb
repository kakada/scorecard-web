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
        expect(response.body).to include(I18n.t("user_guide.guides.system_admin"))
        expect(response.body).to include(I18n.t("user_guide.guides.program_admin"))
        expect(response.body).to include(I18n.t("user_guide.guides.staff"))
        expect(response.body).to include(I18n.t("user_guide.guides.lngo"))
        expect(response.body).to include(I18n.t("user_guide.guides.mobile_app"))
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
        expect(response.body).to include(I18n.t("user_guide.guides.program_admin"))
        expect(response.body).to include(I18n.t("user_guide.guides.program_admin"))
        expect(response.body).to include(I18n.t("user_guide.guides.staff"))
        expect(response.body).to include(I18n.t("user_guide.guides.lngo"))
        expect(response.body).to include(I18n.t("user_guide.guides.mobile_app"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.system_admin"))
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
        expect(response.body).to include(I18n.t("user_guide.guides.staff"))
        expect(response.body).to include(I18n.t("user_guide.guides.lngo"))
        expect(response.body).to include(I18n.t("user_guide.guides.mobile_app"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.system_admin"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.program_admin"))
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
        expect(response.body).to include(I18n.t("user_guide.guides.lngo"))
        expect(response.body).to include(I18n.t("user_guide.guides.mobile_app"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.system_admin"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.program_admin"))
        expect(response.body).not_to include(I18n.t("user_guide.guides.staff"))
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
