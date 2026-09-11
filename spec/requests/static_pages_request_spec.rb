# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:static_page) { create(:static_page, slug: "fam_reporting") }

  describe "as system_admin" do
    let(:user) { create(:user, :system_admin) }

    before { sign_in user }

    it "allows CRUD pages" do
      get "/static_pages"
      expect(response).to have_http_status(:success)

      get "/static_pages/#{static_page.id}"
      expect(response).to have_http_status(:success)

      get "/static_pages/new"
      expect(response).to have_http_status(:success)

      get "/static_pages/#{static_page.id}/edit"
      expect(response).to have_http_status(:success)

      expect {
        post "/static_pages", params: {
          static_page: {
            slug: "new_page",
            content_en: "<p>EN</p>",
            content_km: "<p>KM</p>"
          }
        }
      }.to change(StaticPage, :count).by(1)

      patch "/static_pages/#{static_page.id}", params: { static_page: { content_en: "<p>Updated</p>" } }
      expect(response).to redirect_to(static_page_path(static_page))
      expect(static_page.reload.content_en).to eq("<p>Updated</p>")
    end

    it "shows validation error for duplicate slug" do
      post "/static_pages", params: { static_page: { slug: static_page.slug } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("has already been taken")
    end
  end

  describe "as non-admin" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "denies access to management actions" do
      get "/static_pages"
      expect(response).to redirect_to(root_path)

      get "/static_pages/#{static_page.id}"
      expect(response).to redirect_to(root_path)

      get "/static_pages/new"
      expect(response).to redirect_to(root_path)

      get "/static_pages/#{static_page.id}/edit"
      expect(response).to redirect_to(root_path)

      post "/static_pages", params: { static_page: { slug: "new_page" } }
      expect(response).to redirect_to(root_path)

      patch "/static_pages/#{static_page.id}", params: { static_page: { content_en: "Nope" } }
      expect(response).to redirect_to(root_path)
    end
  end
end
