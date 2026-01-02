# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Jaaps", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:program) { create(:program) }
  let(:user) { create(:user, program: program) }

  before do
    sign_in user
  end

  describe "GET /jaaps" do
    it "returns ok" do
      get jaaps_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /jaaps/new" do
    it "renders new" do
      get new_jaap_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /jaaps" do
    let(:params) do
      {
        jaap: {
          province_id: "01",
          district_id: "001",
          commune_id: "0001",
          data: { rows: [] },
          reference: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/reference_image.png"), "image/png")
        }
      }
    end

    it "creates a jaap and redirects to show" do
      expect {
        post jaaps_path, params: params
      }.to change { Jaap.count }.by(1)

      jaap = Jaap.order(created_at: :desc).first
      expect(jaap.program_id).to eq(program.id)
      expect(jaap.reference).to be_present
      expect(response).to redirect_to(jaap_path(jaap))
    end
  end

  describe "GET /jaaps/:id/edit" do
    let!(:jaap) { create(:jaap, program: program) }

    it "renders edit" do
      get edit_jaap_path(jaap)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /jaaps/:id" do
    let!(:jaap) { create(:jaap, program: program, reference: Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/reference_image.png"), "image/png")) }

    it "updates fields and keeps program scope" do
      patch jaap_path(jaap), params: { jaap: { province_id: "02" } }
      expect(response).to redirect_to(jaap_path(jaap))
      expect(jaap.reload.province_id).to eq("02")
      expect(jaap.program_id).to eq(program.id)
    end

    it "removes reference when remove_reference is set" do
      expect(jaap.reference).to be_present
      patch jaap_path(jaap), params: { jaap: { remove_reference: "1" } }
      expect(response).to redirect_to(jaap_path(jaap))
      expect(jaap.reload.reference.present?).to eq(false)
    end

    it "supports reference_cache when validation fails" do
      # Simulate validation failure by stubbing update to return false.
      allow_any_instance_of(Jaap).to receive(:update).and_return(false)

      file = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/reference_image.png"), "image/png")
      patch jaap_path(jaap), params: { jaap: { reference: file } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('id="jaap_reference_cache"')
    end
  end

  describe "DELETE /jaaps/:id" do
    let!(:jaap) { create(:jaap, program: program) }

    it "destroys and redirects to index" do
      expect {
        delete jaap_path(jaap)
      }.to change { Jaap.count }.by(-1)
      expect(response).to redirect_to(jaaps_path)
    end
  end

  describe "GET /jaaps/:id" do
    let!(:jaap) { create(:jaap, program: program) }

    it "shows the record" do
      get jaap_path(jaap)
      expect(response).to have_http_status(:ok)
    end
  end
end
