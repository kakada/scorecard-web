# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaticPageVariables", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:static_page_variable) { create(:static_page_variable) }

  describe "as system_admin" do
    let(:user) { create(:user, :system_admin) }

    before { sign_in user }

    it "allows CRUD variables" do
      get "/static_page_variables"
      expect(response).to have_http_status(:success)

      get "/static_page_variables/#{static_page_variable.id}"
      expect(response).to redirect_to(static_page_variables_path)

      get "/static_page_variables/new"
      expect(response).to have_http_status(:success)

      get "/static_page_variables/#{static_page_variable.id}/edit"
      expect(response).to have_http_status(:success)

      expect {
        post "/static_page_variables", params: {
          static_page_variable: {
            key: "APP_URL",
            variable_type: "url",
            value: "https://example.com",
            description: "Application URL"
          }
        }
      }.to change(StaticPageVariable, :count).by(1)

      patch "/static_page_variables/#{static_page_variable.id}", params: {
        static_page_variable: {
          value: "Updated value"
        }
      }
      expect(response).to redirect_to(static_page_variables_path)
      expect(static_page_variable.reload.value).to eq("Updated value")

      expect {
        delete "/static_page_variables/#{static_page_variable.id}"
      }.to change(StaticPageVariable, :count).by(-1)
      expect(response).to redirect_to(static_page_variables_path)
    end
  end

  describe "as non-admin" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "denies access to management actions" do
      get "/static_page_variables"
      expect(response).to redirect_to(root_path)

      get "/static_page_variables/#{static_page_variable.id}"
      expect(response).to redirect_to(root_path)

      get "/static_page_variables/new"
      expect(response).to redirect_to(root_path)

      get "/static_page_variables/#{static_page_variable.id}/edit"
      expect(response).to redirect_to(root_path)

      post "/static_page_variables", params: { static_page_variable: { key: "APP_URL" } }
      expect(response).to redirect_to(root_path)

      patch "/static_page_variables/#{static_page_variable.id}", params: { static_page_variable: { value: "Nope" } }
      expect(response).to redirect_to(root_path)

      delete "/static_page_variables/#{static_page_variable.id}"
      expect(response).to redirect_to(root_path)
    end
  end
end
