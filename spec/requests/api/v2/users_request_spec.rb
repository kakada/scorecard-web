# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V2::UsersController", type: :request do
  describe "PUT #lock_access" do
    let!(:user) { create(:user) }
    let(:json_response) { JSON.parse(response.body) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" }
      put "/api/v2/users/lock_access", headers: headers
    }

    it { expect(user.reload.access_locked?).to be_truthy }
    it { expect(response.status).to eq(200) }
  end
end
