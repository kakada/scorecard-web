# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::FamReportingViewsController", type: :request do
  describe "POST /api/v1/fam_reporting_views" do
    it "creates a mobile view count without authentication" do
      expect {
        post "/api/v1/fam_reporting_views"
      }.to change { FamReportingStat.find_by(source: :mobile)&.views_count.to_i }.by(1)

      expect(response).to have_http_status(:created)
    end
  end
end
