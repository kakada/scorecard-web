# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ActivityLogs", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /activity_logs" do
    let(:user) { create(:user, :system_admin) }

    it "returns http success" do
      sign_in user
      get "/activity_logs"
      expect(response).to have_http_status(:success)
    end
  end
end
