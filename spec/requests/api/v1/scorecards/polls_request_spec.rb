# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Scorecards::PollsController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user, :lngo) }
    let!(:facility) { create(:facility, :with_parent, :with_indicators) }
    let!(:scorecard) { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "when authorized and scorecard has ratings" do
      before do
        # 3 distinct participants, some rating multiple times
        participant_uuids = ["p-1", "p-2", "p-3"]
        participant_uuids.each do |pid|
          create(:rating, scorecard: scorecard, participant_uuid: pid)
        end

        # extra rating from an existing participant should not increase the count
        create(:rating, scorecard: scorecard, participant_uuid: "p-1")

        get "/api/v1/scorecards/#{scorecard.uuid}/poll", headers: headers
      end

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response.status).to eq(200) }

      it "returns total_votes equal to distinct participants in ratings" do
        json_response = JSON.parse(response.body)

        expect(json_response["total_votes"]).to eq(3)
      end
    end

    context "when scorecard has no ratings" do
      before do
        get "/api/v1/scorecards/#{scorecard.uuid}/poll", headers: headers
      end

      it { expect(response.status).to eq(200) }

      it "returns total_votes as zero" do
        json_response = JSON.parse(response.body)

        expect(json_response["total_votes"]).to eq(0)
      end
    end

    context "when accessing scorecard from different local ngo" do
      let!(:other_scorecard) { create(:scorecard) }
      let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

      before do
        get "/api/v1/scorecards/#{other_scorecard.uuid}/poll", headers: headers
      end

      it "returns 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end
  end
end
