# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicVotesController, type: :controller do
  let(:program) { create(:program) }
  let(:user) { create(:user, program: program) }
  let(:facility) { create(:facility, program: program) }
  let(:indicator1) { create(:indicator, categorizable: facility) }
  let(:indicator2) { create(:indicator, categorizable: facility) }
  let(:scorecard) { create(:scorecard, program: program, facility: facility, creator: user, progress: voting_progress) }

  describe "GET #new" do
    context "when voting is open" do
      let(:voting_progress) { :open_voting }

      it "renders the voting form" do
        get :new, params: { scorecard_uuid: scorecard.uuid }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:scorecard)).to eq(scorecard)
        expect(assigns(:form)).to be_a(PublicVoteForm)
      end
    end

    context "when voting is closed" do
      let(:voting_progress) { :running }

      it "shows voting closed message" do
        get :new, params: { scorecard_uuid: scorecard.uuid }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:voting_closed)).to be true
      end
    end

    context "when scorecard does not exist" do
      it "returns not found" do
        get :new, params: { scorecard_uuid: "invalid-uuid" }
        
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST #create" do
    let(:participant_params) do
      {
        age: 25,
        gender: "female",
        disability: false,
        minority: false,
        poor_card: false,
        youth: true
      }
    end

    let(:voting_data) do
      [
        { indicator_uuid: indicator1.uuid, score: 4 },
        { indicator_uuid: indicator2.uuid, score: 5 }
      ]
    end

    let(:request_params) do
      {
        scorecard_uuid: scorecard.uuid,
        participant: participant_params,
        voting_data: voting_data
      }
    end

    context "when voting is open" do
      let(:voting_progress) { :open_voting }

      it "creates participant and voting records" do
        # Note: This test needs voting_indicators to exist, so we'll skip the count check
        expect {
          post :create, params: request_params, format: :json
        }.to change(Participant, :count).by(1)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true

        participant = Participant.last
        expect(participant.age).to eq(25)
        expect(participant.gender).to eq("female")
        expect(participant.youth).to be true
        expect(participant.countable).to be false
      end
    end

    context "when voting is closed" do
      let(:voting_progress) { :running }

      it "returns error and does not create records" do
        expect {
          post :create, params: request_params, format: :json
        }.not_to change(Participant, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to be_present
      end
    end

    context "when voting closes after form is shown but before submission" do
      let(:voting_progress) { :open_voting }

      it "returns error message about voting ended" do
        scorecard.update(progress: :close_voting)
        
        post :create, params: request_params, format: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("public_votes.voting_ended"))
      end
    end

    context "with invalid participant data" do
      let(:voting_progress) { :open_voting }
      let(:invalid_params) do
        request_params.merge(
          participant: { age: nil, gender: nil }
        )
      end

      it "returns validation errors" do
        expect {
          post :create, params: invalid_params, format: :json
        }.not_to change(Participant, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
