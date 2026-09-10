# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FamReportingStats", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /fam_reporting_stats" do
    let!(:web_stat) { create(:fam_reporting_stat, source: :web, views_count: 3) }
    let!(:mobile_stat) { create(:fam_reporting_stat, source: :mobile, views_count: 2) }

    context "when user is program_admin" do
      let(:user) { create(:user) }

      it "returns http success and shows tracked counts" do
        sign_in user

        get "/fam_reporting_stats"

        expect(response).to have_http_status(:success)
        expect(response.body).to include(I18n.t("fam_reporting.sources.web"))
        expect(response.body).to include(I18n.t("fam_reporting.sources.mobile"))
        expect(response.body).to include("3")
        expect(response.body).to include("2")
      end
    end

    context "when user is lngo" do
      let(:user) { create(:user, :lngo) }

      it "redirects back to the homepage" do
        sign_in user

        get "/fam_reporting_stats"

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
