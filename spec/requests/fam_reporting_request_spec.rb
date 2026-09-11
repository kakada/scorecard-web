# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FamReporting", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:browser_headers) do
    { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36" }
  end

  describe "GET /fam_reporting" do
    context "when the visitor is not signed in" do
      it "returns http success" do
        get "/fam_reporting", headers: browser_headers
        expect(response).to have_http_status(:success)
      end

      it "renders without the footer" do
        get "/fam_reporting", headers: browser_headers
        assert_select "footer", count: 0
      end

      it "tracks a view_fam_reporting event" do
        expect {
          get "/fam_reporting", headers: browser_headers
        }.to change(Ahoy::Event, :count).by(1)

        expect(Ahoy::Event.last.name).to eq("view_fam_reporting")
      end
    end

    context "when the visitor is signed in" do
      let(:user) { create(:user) }
      let!(:static_page) { create(:static_page, slug: "/fam_reporting", content_km: "<h1>KM Content</h1>", content_en: "<h1>EN Content</h1>") }

      before { sign_in user }

      it "returns http success" do
        get "/fam_reporting", headers: browser_headers
        expect(response).to have_http_status(:success)
      end

      it "tracks a view_fam_reporting event" do
        expect {
          get "/fam_reporting", headers: browser_headers
        }.to change(Ahoy::Event, :count).by(1)
      end

      it "loads copy from static page slug" do
        get "/fam_reporting", headers: browser_headers

        expect(response.body).to include("KM Content")
      end
    end
  end
end
