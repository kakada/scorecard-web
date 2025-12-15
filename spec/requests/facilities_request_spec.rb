# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Facilities", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:program) { create(:program) }
  let(:program_admin) { create(:user, :program_admin, program: program) }
  let(:facility) { create(:facility, program: program, default: false) }
  let(:default_facility) { create(:facility, program: program, default: true) }

  describe "GET /facilities/:id/edit" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "returns http success for non-default facility" do
        get edit_facility_path(facility)
        expect(response).to have_http_status(:success)
      end

      it "allows editing default facility" do
        get edit_facility_path(default_facility)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /facilities/:id" do
    context "when user is program admin" do
      before { sign_in program_admin }

      it "updates the facility" do
        patch facility_path(facility), params: { facility: { name_en: "Updated Name" } }
        expect(response).to have_http_status(:found)
        expect(facility.reload.name_en).to eq("Updated Name")
      end

      it "updates category_id for non-default facility" do
        category = create(:category)
        patch facility_path(facility), params: { facility: { category_id: category.id } }
        expect(response).to have_http_status(:found)
        expect(facility.reload.category_id).to eq(category.id)
      end
    end
  end
end
