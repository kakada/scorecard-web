require 'rails_helper'

RSpec.describe "ActivityLogs", type: :request do

  describe "GET /activity_logs" do
    it "returns http success" do
      get "/activity_logs"
      expect(response).to have_http_status(:success)
    end
  end

end
