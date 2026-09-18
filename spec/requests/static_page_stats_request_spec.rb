# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaticPageStats", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /static_page_stats" do
    let!(:fam_reporting_page) { create(:static_page, slug: "fam_reporting") }
    let!(:privacy_policy_page) { create(:static_page, slug: "privacy_policy") }

    let!(:fam_reporting_events) do
      create_list(:ahoy_visit, 2, platform: "web").map do |visit|
        create(:ahoy_event, visit: visit, name: "view_fam_reporting")
      end
    end

    let!(:privacy_policy_events) do
      create_list(:ahoy_visit, 1, platform: "iOS").map do |visit|
        create(:ahoy_event, visit: visit, name: "view_privacy_policy")
      end
    end

    context "when user is program_admin" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "returns http success and shows tracked counts across all static pages" do
        get "/static_page_stats"

        expect(response).to have_http_status(:success)
        expect(response.body).to include("view_fam_reporting")
        expect(response.body).to include("view_privacy_policy")
      end

      it "filters events by the selected static page" do
        get "/static_page_stats", params: { name: [fam_reporting_page.event_name] }

        expect(response).to have_http_status(:success)

        table_body = Nokogiri::HTML(response.body).at("tbody").text
        expect(table_body).to include("view_fam_reporting")
        expect(table_body).not_to include("view_privacy_policy")
      end

      it "filters events by time range" do
        create(:ahoy_event, visit: create(:ahoy_visit, os: "AncientOS"), name: "view_fam_reporting", time: 1.year.ago)

        get "/static_page_stats", params: { start_time: 2.days.ago.to_date.to_s, end_time: Date.tomorrow.to_s }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("view_fam_reporting")
        expect(response.body).not_to include("AncientOS")
      end
    end

    context "when user is lngo" do
      let(:user) { create(:user, :lngo) }

      it "redirects back to the homepage" do
        sign_in user

        get "/static_page_stats"

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
