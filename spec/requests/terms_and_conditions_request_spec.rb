# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TermsAndConditions", type: :request do
  describe "GET /terms_and_conditions" do
    it "returns http success without authentication" do
      get "/terms_and_conditions"
      expect(response).to have_http_status(:success)
    end
  end
end
