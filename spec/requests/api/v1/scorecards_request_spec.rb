# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::ScorecardsController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:scorecard)  { create(:scorecard, program: user.program) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    before {
      get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
    }

    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response.status).to eq(200) }
    it { expect(response.body).not_to be_nil }

    context "different local ngo" do
      let!(:user) { create(:user, :lngo) }
      let!(:scorecard) { create(:scorecard) }
      let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

      before {
        get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
      }

      it "return 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end

    context "same local ngo" do
      let!(:user) { create(:user, :lngo) }
      let!(:scorecard) { create(:scorecard, local_ngo_id: user.local_ngo_id, program: user.program) }
      let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

      before {
        get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
      }

      it { expect(response.status).to eq(200) }
    end
  end

  describe "GET #show" do
    context "different program" do
      let!(:user) { create(:user) }
      let!(:scorecard) { create(:scorecard) }
      let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

      before {
        get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
      }

      it "return 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end
  end

  describe "PUT #update" do
    let!(:user)       { create(:user) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program_uuid: user.program_uuid) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { number_of_caf: 3, number_of_participant: 15, number_of_female: 5 } }

    context "success" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.number_of_participant).to eq(15) }
    end

    context "is locked" do
      before {
        scorecard.lock_access!
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it "return 403" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(403)
      end
    end

    context "scorecard is not found" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}abc", params: { scorecard: params }, headers: headers
      }

      it "return 404" do
        expect(JSON.parse(response.body)["errors"][0]["code"]).to eq(404)
      end
    end

    context "update and lock_access" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it "lock_access" do
        expect(scorecard.reload.access_locked?).to be_truthy
      end
    end
  end

  describe "PUT #update, suggested_actions_attributes" do
    let!(:user)       { create(:user) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)   { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { voting_indicators_attributes: [ {
                          uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, scorecard_uuid: scorecard.uuid,
                          suggested_actions_attributes: [
                            { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action1", selected: true },
                            { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action2", selected: false },
                          ]
                        }] }
                      }
    let(:voting_indicators) { scorecard.reload.voting_indicators }

    context "success" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(voting_indicators.length).to eq(1) }
      it { expect(voting_indicators.first.suggested_actions.length).to eq(2) }
      it { expect(voting_indicators.first.suggested_actions.selecteds.length).to eq(1) }
    end
  end

  describe "PUT #update, facilitators_attributes with soft delete caf" do
    let!(:user)       { create(:user) }
    let!(:local_ngo)  { create(:local_ngo, program: user.program) }
    let!(:caf1)        { create(:caf, local_ngo: local_ngo) }
    let!(:caf2)        { create(:caf, local_ngo: local_ngo) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, local_ngo: local_ngo) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { {
                          facilitators_attributes: [
                            { caf_id: caf1.id, position: "lead", scorecard_uuid: scorecard.uuid },
                            { caf_id: caf2.id, position: "other", scorecard_uuid: scorecard.uuid },
                          ]
                        }
                      }
    context "success" do
      before {
        caf2.destroy
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.facilitators.length).to eq(2) }
    end
  end
end
