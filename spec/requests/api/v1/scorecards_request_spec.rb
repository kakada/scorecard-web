# frozen_string_literal: true

require "rails_helper"
require "stringio"

RSpec.describe "Api::V1::ScorecardsController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:scorecard)  { create(:scorecard, program_id: user.program_id) }
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
      let!(:scorecard) { create(:scorecard, local_ngo_id: user.local_ngo_id, program_id: user.program_id) }
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
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program_id: user.program_id) }
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
        scorecard.lock_submit!
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

      it "lock_submit" do
        expect(scorecard.reload.submit_locked?).to be_truthy
      end
    end
  end

  describe "PUT #update, suggested_actions_attributes" do
    let!(:user)       { create(:user) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)   { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { voting_indicators_attributes: [ {
                          uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, scorecard_uuid: scorecard.uuid, display_order: 1,
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
      it { expect(voting_indicators.first.display_order).to eq(1) }
    end
  end

  describe "PUT #update, facilitators_attributes with soft delete caf" do
    let!(:user)       { create(:user) }
    let!(:local_ngo)  { create(:local_ngo, program: user.program) }
    let!(:caf1)        { create(:caf, local_ngo: local_ngo) }
    let!(:caf2)        { create(:caf, local_ngo: local_ngo) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, local_ngo: local_ngo) }
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

  describe "GET #show, pdf" do
    let!(:user)      { create(:user) }
    let!(:scorecard) { create(:scorecard, program: user.program) }
    let!(:province)  { Pumi::Province.find_by_id(scorecard.province_id) }
    let(:headers)    { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let!(:pdf_template) { create(:pdf_template, program: scorecard.program, content: "{{scorecard.province}}") }

    context "scorecard is finished" do
      before {
        scorecard.lock_access!
        get "/api/v1/scorecards/#{scorecard.uuid}.pdf", headers: headers
      }

      it { expect(response.code).to eq("200") }
      it { expect(response.headers["Content-Type"]).to eq("application/pdf") }
      it { expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"scorecard_#{scorecard.uuid}.pdf\"; filename*=UTF-8''scorecard_#{scorecard.uuid}.pdf") }
    end

    context "scorecard is not finished" do
      before {
        get "/api/v1/scorecards/#{scorecard.uuid}.pdf", headers: headers
      }

      it { expect(response.code).to eq("403") }
    end

    context "pass params locale" do
      let(:reader) { PDF::Reader.new(StringIO.new(response.body)) }

      before { scorecard.lock_access! }

      context "locale is :en" do
        before {
          get "/api/v1/scorecards/#{scorecard.uuid}.pdf?locale=en", headers: headers
        }

        it { expect(reader.page(1).text).to eq(province.name_en) }
      end

      context "locale is :km" do
        before {
          get "/api/v1/scorecards/#{scorecard.uuid}.pdf?locale=km", headers: headers
        }

        it { expect(reader.page(1).text).not_to eq(province.name_en) }
      end
    end
  end

  describe "PUT #update, raised_indicator and voting_indicators" do
    let!(:user)       { create(:user) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:custom_indicator) { create(:indicator, type: "Indicators::CustomIndicator", categorizable: facility) }
    let!(:custom_indicator2) { create(:indicator, type: "Indicators::CustomIndicator", categorizable: facility) }
    let!(:indicator)   { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { raised_indicators_attributes: [
                            { indicatorable_id: indicator.id, indicatorable_type: "Indicator", scorecard_uuid: scorecard.uuid, voting_indicator_uuid: "123", selected: true },
                            { indicatorable_id: custom_indicator.id, indicatorable_type: "CustomIndicator", scorecard_uuid: scorecard.uuid, voting_indicator_uuid: "124", selected: true },
                            { indicatorable_id: custom_indicator2.id, indicatorable_type: "Indicators::CustomIndicator", scorecard_uuid: scorecard.uuid, voting_indicator_uuid: "125", selected: true },
                          ],
                          voting_indicators_attributes: [
                            { uuid: "123", indicatorable_id: indicator.id, indicatorable_type: "Indicator", scorecard_uuid: scorecard.uuid, display_order: 1 },
                            { uuid: "124", indicatorable_id: custom_indicator.id, indicatorable_type: "CustomIndicator", scorecard_uuid: scorecard.uuid, display_order: 2 },
                            { uuid: "125", indicator_uuid: custom_indicator2.uuid, indicatorable_id: custom_indicator2.id, indicatorable_type: "Indicators::CustomIndicator", scorecard_uuid: scorecard.uuid, display_order: 2 },
                          ]
                        }
                      }
    let(:voting_indicators) { scorecard.reload.voting_indicators }
    let(:raised_indicators) { scorecard.reload.raised_indicators }

    context "success" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(voting_indicators.length).to eq(3) }
      it { expect(raised_indicators.length).to eq(3) }
      it { expect(raised_indicators.first.selected).to be_truthy }
      it { expect(raised_indicators.first.voting_indicator_uuid).to eq("123") }
    end
  end

  describe "PUT #update, proposed_indicator_actions" do
    let!(:user)       { create(:user) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)  { facility.indicators.first }
    let!(:predefined_suggested_action) { create(:indicator_action, code: "1111", indicator: indicator) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
    let!(:headers)    { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "proposed_indicator_actions" do
      let!(:params) {
        {
          voting_indicators_attributes: [
            {
              uuid: "123",
              indicatorable_id: indicator.id,
              indicatorable_type: "Indicator",
              scorecard_uuid: scorecard.uuid,
              display_order: 1,

              proposed_indicator_actions_attributes: [
                {
                  voting_indicator_uuid: "123",
                  indicator_action_id: predefined_suggested_action.id,
                  selected: true,
                  scorecard_uuid: scorecard.uuid
                },
                {
                  voting_indicator_uuid: "123",
                  selected: false,
                  scorecard_uuid: scorecard.uuid,
                  indicator_action_attributes: {
                    name: "custom action",
                    kind: "suggested_action",
                    predefined: false,
                    indicator_uuid: indicator.uuid
                  }
                }
              ]
            },
          ]
        }
      }
      let(:voting_indicators) { scorecard.reload.voting_indicators }

      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(voting_indicators.length).to eq(1) }
      it { expect(voting_indicators.first.proposed_indicator_actions.length).to eq(2) }
      it { expect(indicator.indicator_actions.length).to eq(2) }
      it { expect(indicator.indicator_actions.customs.length).to eq(1) }
      it { expect(scorecard.proposed_indicator_actions.length).to eq(2) }
    end

    context "indicator activity" do
      let!(:params) {
        {
          voting_indicators_attributes: [
            {
              uuid: "123",
              indicatorable_id: indicator.id,
              indicatorable_type: "Indicator",
              display_order: 1,
              indicator_activities_attributes: [
                {
                  voting_indicator_uuid: "123",
                  content: "weakness action",
                  selected: false,
                  scorecard_uuid: scorecard.uuid,
                  type: "WeaknessIndicatorActivity"
                },
                {
                  voting_indicator_uuid: "123",
                  content: "suggested_action",
                  selected: true,
                  scorecard_uuid: scorecard.uuid,
                  type: "SuggestedIndicatorActivity"
                }
              ]
            }
          ]
        }
      }

      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(scorecard.proposed_indicator_actions.suggested_action.length).to eq(1) }
      it { expect(scorecard.proposed_indicator_actions.weakness.length).to eq(1) }
    end
  end
end
