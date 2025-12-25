# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Jaaps", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:program) { create(:program) }
  let(:program_admin) { create(:user, :program_admin, program: program) }
  let(:staff) { create(:user, :staff, program: program) }
  let(:jaap) { create(:jaap, program: program, user: program_admin) }

  describe "GET /jaaps" do
    context "when user is authenticated" do
      before { sign_in program_admin }

      it "returns http success" do
        get jaaps_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /jaaps/:uuid" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "returns http success" do
        get jaap_path(jaap.uuid)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /jaaps/new" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "returns http success" do
        get new_jaap_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /jaaps" do
    context "when user is program admin" do
      before { sign_in program_admin }

      let(:valid_params) do
        {
          jaap: {
            title: "Test JAAP",
            description: "Test description",
            field_definitions: Jaap.default_field_definitions.to_json,
            rows_data: [{ issue: "Test issue", action: "Test action" }].to_json
          }
        }
      end

      it "creates a new JAAP" do
        expect {
          post jaaps_path, params: valid_params
        }.to change(Jaap, :count).by(1)
      end

      it "redirects to the created JAAP" do
        post jaaps_path, params: valid_params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(jaap_path(Jaap.last.uuid))
      end
    end
  end

  describe "GET /jaaps/:uuid/edit" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "returns http success" do
        get edit_jaap_path(jaap.uuid)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /jaaps/:uuid" do
    context "when user is program admin" do
      before { sign_in program_admin }

      let(:update_params) do
        {
          jaap: {
            title: "Updated Title",
            description: "Updated description"
          }
        }
      end

      it "updates the JAAP" do
        patch jaap_path(jaap.uuid), params: update_params
        expect(response).to have_http_status(:found)
        expect(jaap.reload.title).to eq("Updated Title")
      end
    end
  end

  describe "DELETE /jaaps/:uuid" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "deletes the JAAP" do
        jaap # create the JAAP
        expect {
          delete jaap_path(jaap.uuid)
        }.to change(Jaap, :count).by(-1)
      end

      it "redirects to jaaps index" do
        delete jaap_path(jaap.uuid)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(jaaps_path)
      end
    end
  end

  describe "PUT /jaaps/:uuid/complete" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "marks the JAAP as completed" do
        put complete_jaap_path(jaap.uuid)
        expect(jaap.reload.completed?).to be true
      end

      it "redirects to the JAAP" do
        put complete_jaap_path(jaap.uuid)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(jaap_path(jaap.uuid))
      end
    end
  end
end
