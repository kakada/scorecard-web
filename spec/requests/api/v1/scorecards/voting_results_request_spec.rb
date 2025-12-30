# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Scorecards::VotingResultsController", type: :request do
  describe "GET #index" do
    let!(:user) { create(:user, :lngo) }
    let!(:facility) { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator) { facility.indicators.first }
    let!(:scorecard) { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility_id: facility.id) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "with voting indicators" do
      let!(:voting_indicator1) do
        create(:voting_indicator,
               scorecard_uuid: scorecard.id,
               indicatorable_id: indicator.id,
               indicatorable_type: "Indicator",
               median: :good,
               display_order: 1)
      end
      let!(:voting_indicator2) do
        create(:voting_indicator,
               scorecard_uuid: scorecard.id,
               indicatorable_id: indicator.id,
               indicatorable_type: "Indicator",
               median: :acceptable,
               display_order: 2)
      end

      before do
        get "/api/v1/scorecards/#{scorecard.uuid}/voting_results", headers: headers
      end

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response.status).to eq(200) }

      it "returns an array of voting indicators" do
        json_response = JSON.parse(response.body)

        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(2)
      end
    end

    context "without voting indicators" do
      before do
        # Ensure no voting indicators exist for this scorecard
        scorecard.voting_indicators.destroy_all
        get "/api/v1/scorecards/#{scorecard.uuid}/voting_results", headers: headers
      end

      it { expect(response.status).to eq(200) }

      it "returns empty array" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end

    context "different local ngo" do
      let!(:other_user) { create(:user, :lngo) }
      let!(:other_scorecard) { create(:scorecard) }
      let(:other_headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{other_user.authentication_token}" } }

      before do
        get "/api/v1/scorecards/#{other_scorecard.uuid}/voting_results", headers: other_headers
      end

      it "returns 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end
  end
end
