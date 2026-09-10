# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FamReporting", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /fam_reporting" do
    it "returns http success without authentication and tracks a web view" do
      expect {
        get "/fam_reporting"
      }.to change { FamReportingStat.find_by(source: :web)&.views_count.to_i }.by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/sign_in" do
    it "shows the fam reporting link" do
      get new_user_session_path

      expect(response.body).to include(fam_reporting_path)
      expect(response.body).to include(I18n.t("fam_reporting.report_concern"))
    end
  end

  describe "GET /" do
    let(:user) { create(:user) }

    it "shows the fam reporting notification on the homepage" do
      sign_in user

      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t("fam_reporting.homepage_notification_title"))
      expect(response.body).to include(fam_reporting_path)
    end
  end
end
