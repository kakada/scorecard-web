# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PrivacyPolicies", type: :request do
  describe "GET /privacy_policy" do
    it "returns http success without authentication" do
      get "/privacy_policy"
      expect(response).to have_http_status(:success)
    end
  end
end
