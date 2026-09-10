# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FamReportingStats", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /fam_reporting_stats" do
    let!(:web_events) do
      create_list(:ahoy_visit, 2, platform: "web").map do |visit|
        create(:ahoy_event, visit: visit, name: "view_fam_reporting")
      end
    end

    let!(:mobile_events) do
      create_list(:ahoy_visit, 1, platform: "iOS").map do |visit|
        create(:ahoy_event, visit: visit, name: "view_fam_reporting")
      end
    end

    context "when user is program_admin" do
      let(:user) { create(:user) }

      it "returns http success and shows tracked counts" do
        sign_in user

        get "/fam_reporting_stats"

        expect(response).to have_http_status(:success)
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
