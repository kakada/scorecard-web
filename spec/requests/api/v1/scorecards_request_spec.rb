# frozen_string_literal: true

require "rails_helper"
require "stringio"

RSpec.describe "Api::V1::ScorecardsController", type: :request do
  describe "GET #show" do
    context "scorecard belongs to the same lngo to logged in user" do
      let!(:user) { create(:user, :lngo) }
      let!(:facility) { create(:facility, :primary_school_with_dataset, program: user.program) }
      let(:dataset)  { facility.category.datasets.first }
      let!(:scorecard)  { create(:scorecard, facility: facility, program_id: user.program_id, local_ngo_id: user.local_ngo_id, dataset_id: dataset.id) }
      let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

      before {
        get "/api/v1/scorecards/#{scorecard.uuid}", headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response.status).to eq(200) }
      it { expect(response.body).not_to be_nil }

      it "returns the expected scorecard data" do
        json_response = JSON.parse(response.body)

        expect(json_response["uuid"]).to eq(scorecard.uuid)
        expect(json_response["number_of_participant"]).to eq(scorecard.number_of_participant)
        expect(json_response["dataset"]["category_name_en"]).to eq(dataset.category.name_en)
        expect(json_response["dataset"]["category_name_km"]).to eq(dataset.category.name_km)
      end

      it "includes running_mode in the response" do
        json_response = JSON.parse(response.body)

        expect(json_response).to have_key("running_mode")
      end
    end

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
    let!(:user)       { create(:user, :lngo) }
    let!(:scorecard)  { create(:scorecard, running_mode: "offline", number_of_participant: 3, program_id: user.program_id, local_ngo_id: user.local_ngo_id) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { number_of_caf: 3, number_of_participant: 15, app_version: 15013 } }

    context "success" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it { expect(response.content_type).to eq("application/json; charset=utf-8") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.app_version).to eq(15013) }
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

    context "update without indicator activities does not lock" do
      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      }

      it "does not lock submission" do
        expect(scorecard.reload.submit_locked?).to be_falsey
      end
    end

    context "update with indicator activities locks submission" do
      let(:final_submit_params) do
        {
          voting_indicators_attributes: [
            {
              uuid: "vi-123",
              indicator_activities_attributes: [
                { voting_indicator_uuid: "vi-123", content: "activity 1", selected: true, type: "IndicatorActivity" }
              ]
            }
          ]
        }
      end

      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: final_submit_params }, headers: headers
      }

      it "locks submission" do
        expect(scorecard.reload.submit_locked?).to be_truthy
      end
    end

    context "program is sandbox" do
      before do
        user.program.update!(sandbox: true)
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: params }, headers: headers
      end

      it { expect(response).to have_http_status(:ok) }

      it "does not update attributes or lock submission" do
        sc = scorecard.reload
        expect(sc.app_version).to be_nil    # unchanged
        expect(sc.submit_locked?).to be_falsey
      end
    end
  end

  describe "PUT #update, indicator_activities_attributes" do
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)   { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { voting_indicators_attributes: [ {
                          uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, display_order: 1,
                          indicator_activities_attributes: [
                            { voting_indicator_uuid: "123", content: "action1", selected: true, type: "SuggestedIndicatorActivity" },
                            { voting_indicator_uuid: "123", content: "action2", selected: false, type: "SuggestedIndicatorActivity" },
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
      it { expect(voting_indicators.first.suggested_indicator_activities.length).to eq(2) }
      it { expect(voting_indicators.first.suggested_indicator_activities.select { |act| act.selected? }.length).to eq(1) }
      it { expect(voting_indicators.first.display_order).to eq(1) }
    end
  end

  describe "PUT #update, online mode two-step" do
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)  { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "first submit without activities (draft)" do
      let(:first_params) do
        {
          app_version: 15013,
          voting_indicators_attributes: [
            { uuid: "vi-001", indicatorable_id: indicator.id, indicatorable_type: indicator.class, display_order: 1 }
          ]
        }
      end

      before {
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: first_params }, headers: headers
      }

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.submit_locked?).to be_falsey }
      it { expect(scorecard.reload.voting_indicators.map(&:uuid)).to include("vi-001") }
    end

    context "second submit with activities (final)" do
      let(:second_params) do
        {
          voting_indicators_attributes: [
            {
              id: "vi-001",
              uuid: "vi-001",
              indicator_activities_attributes: [
                { voting_indicator_uuid: "vi-001", content: "activity 1", selected: true, type: "SuggestedIndicatorActivity" }
              ]
            }
          ]
        }
      end

      before do
        # Ensure the first step has created the voting indicator
        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: {
          voting_indicators_attributes: [ { uuid: "vi-001", indicatorable_id: indicator.id, indicatorable_type: indicator.class, display_order: 1 } ]
        } }, headers: headers

        put "/api/v1/scorecards/#{scorecard.uuid}", params: { scorecard: second_params }, headers: headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.submit_locked?).to be_truthy }
      it { expect(scorecard.reload.voting_indicators.first.suggested_indicator_activities.length).to eq(1) }
      it { expect(scorecard.reload.voting_indicators.length).to eq(1) }
    end
  end

  describe "PUT #update, facilitators_attributes with soft delete caf" do
    let!(:local_ngo)  { create(:local_ngo) }
    let!(:user)       { create(:user, :lngo, local_ngo: local_ngo, program: local_ngo.program) }
    let!(:caf1)        { create(:caf, local_ngo: local_ngo) }
    let!(:caf2)        { create(:caf, local_ngo: local_ngo) }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, local_ngo: local_ngo) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { {
                          facilitators_attributes: [
                            { caf_id: caf1.id, position: "lead" },
                            { caf_id: caf2.id, position: "other" },
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

  pending "GET #show, pdf" do
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
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:custom_indicator) { create(:indicator, type: "Indicators::CustomIndicator", categorizable: facility) }
    let!(:custom_indicator2) { create(:indicator, type: "Indicators::CustomIndicator", categorizable: facility) }
    let!(:indicator)   { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility, local_ngo_id: user.local_ngo_id) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }
    let(:params)      { { raised_indicators_attributes: [
                            { indicatorable_id: indicator.id, indicatorable_type: "Indicator", voting_indicator_uuid: "123", selected: true },
                            { indicatorable_id: custom_indicator.id, indicatorable_type: "CustomIndicator", voting_indicator_uuid: "124", selected: true },
                            { indicatorable_id: custom_indicator2.id, indicatorable_type: "Indicators::CustomIndicator", voting_indicator_uuid: "125", selected: true },
                          ],
                          voting_indicators_attributes: [
                            { uuid: "123", indicatorable_id: indicator.id, indicatorable_type: "Indicator", display_order: 1 },
                            { uuid: "124", indicatorable_id: custom_indicator.id, indicatorable_type: "CustomIndicator", display_order: 2 },
                            { uuid: "125", indicator_uuid: custom_indicator2.uuid, indicatorable_id: custom_indicator2.id, indicatorable_type: "Indicators::CustomIndicator", display_order: 2 },
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

  describe "PUT #update, automatic participant demographics calculation for online scorecard" do
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)  { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility, running_mode: :online) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "final submit calculates demographics from participants" do
      before do
        # Create participants first
        scorecard.participants.create!(uuid: "p1", gender: "female", disability: true, minority: false, youth: true, poor_card: false, countable: true)
        scorecard.participants.create!(uuid: "p2", gender: "male", disability: false, minority: true, youth: false, poor_card: true, countable: true)
        scorecard.participants.create!(uuid: "p3", gender: "female", disability: true, minority: true, youth: true, poor_card: true, countable: true)

        # Final submit with indicator activities
        put "/api/v1/scorecards/#{scorecard.uuid}", params: {
          scorecard: {
            number_of_participant: 999, # This should be ignored for online scorecards
            number_of_female: 999,
            voting_indicators_attributes: [
              {
                uuid: "vi-001",
                indicatorable_id: indicator.id,
                indicatorable_type: indicator.class,
                display_order: 1,
                indicator_activities_attributes: [
                  { voting_indicator_uuid: "vi-001", content: "activity 1", selected: true, type: "SuggestedIndicatorActivity" }
                ]
              }
            ]
          }
        }, headers: headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.submit_locked?).to be_truthy }

      it "calculates number_of_participant from participants" do
        expect(scorecard.reload.number_of_participant).to eq(3)
      end

      it "calculates number_of_female from participants" do
        expect(scorecard.reload.number_of_female).to eq(2)
      end

      it "calculates number_of_disability from participants" do
        expect(scorecard.reload.number_of_disability).to eq(2)
      end

      it "calculates number_of_ethnic_minority from participants" do
        expect(scorecard.reload.number_of_ethnic_minority).to eq(2)
      end

      it "calculates number_of_youth from participants" do
        expect(scorecard.reload.number_of_youth).to eq(2)
      end

      it "calculates number_of_id_poor from participants" do
        expect(scorecard.reload.number_of_id_poor).to eq(2)
      end
    end

    context "draft submit does not calculate demographics" do
      before do
        # Create participants
        scorecard.participants.create!(uuid: "p1", gender: "female", disability: true, minority: false, youth: true, poor_card: false, countable: true)

        # Draft submit without indicator activities
        put "/api/v1/scorecards/#{scorecard.uuid}", params: {
          scorecard: {
            number_of_participant: 10,
            voting_indicators_attributes: [
              { uuid: "vi-001", indicatorable_id: indicator.id, indicatorable_type: indicator.class, display_order: 1 }
            ]
          }
        }, headers: headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.submit_locked?).to be_falsey }

      it "uses participants callback demographics" do
        expect(scorecard.reload.number_of_participant).to eq(1) # it is counted from online voted participants
      end
    end
  end

  describe "PUT #update, offline scorecard uses submitted demographics" do
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)  { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility, running_mode: :offline) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    context "final submit uses submitted demographics" do
      before do
        # Final submit with indicator activities and submitted demographics
        put "/api/v1/scorecards/#{scorecard.uuid}", params: {
          scorecard: {
            voting_indicators_attributes: [
              {
                uuid: "vi-001",
                indicatorable_id: indicator.id,
                indicatorable_type: indicator.class,
                display_order: 1,
                indicator_activities_attributes: [
                  { voting_indicator_uuid: "vi-001", content: "activity 1", selected: true, type: "SuggestedIndicatorActivity" }
                ]
              }
            ],
            participants_attributes: [
              { uuid: "p1", gender: "female", disability: true, minority: false, youth: true, poor_card: false, countable: true },
              { uuid: "p2", gender: "male", disability: false, minority: true, youth: false, poor_card: true, countable: true },
            ]
          }
        }, headers: headers
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(scorecard.reload.submit_locked?).to be_truthy }

      it "uses participants callback demographics" do
        expect(scorecard.reload.number_of_participant).to eq(2)
        expect(scorecard.reload.number_of_female).to eq(1)
        expect(scorecard.reload.number_of_disability).to eq(1)
        expect(scorecard.reload.number_of_ethnic_minority).to eq(1)
        expect(scorecard.reload.number_of_youth).to eq(1)
        expect(scorecard.reload.number_of_id_poor).to eq(1)
      end
    end
  end

  describe "PUT #update, online scorecard voting duplicates request" do
    let!(:user)       { create(:user, :lngo) }
    let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
    let!(:indicator)  { facility.indicators.first }
    let!(:scorecard)  { create(:scorecard, program: user.program, local_ngo_id: user.local_ngo_id, facility: facility, running_mode: :online) }
    let(:headers)     { { "ACCEPT" => "application/json", "Authorization" => "Token #{user.authentication_token}" } }

    it "does not create duplicate voting_indicators on repeated submissions" do
      expect(scorecard.voting_indicators.count).to eq(0)

      first_params = {
        scorecard: {
          voting_indicators_attributes: [
            { uuid: "vi-123", indicator_uuid: indicator.uuid, display_order: 1 }
          ]
        }
      }

      put "/api/v1/scorecards/#{scorecard.uuid}", params: first_params, headers: headers
      expect(response).to have_http_status(:ok)
      scorecard.reload
      expect(scorecard.voting_indicators.count).to eq(1)

      # Submit the same indicator again (no id provided)
      second_params = {
        scorecard: {
          voting_indicators_attributes: [
            { uuid: "vi-123", indicator_uuid: indicator.uuid, display_order: 1 }
          ]
        }
      }

      put "/api/v1/scorecards/#{scorecard.uuid}", params: second_params, headers: headers

      expect(response).to have_http_status(:ok)

      scorecard.reload
      expect(scorecard.voting_indicators.count).to eq(1)

      # Ensure the record corresponds to the indicator
      vi = scorecard.voting_indicators.first
      expect(vi.indicator_uuid).to eq(indicator.uuid)
    end
  end
end
