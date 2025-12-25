# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicVotesController, type: :controller do
  let(:program) { create(:program) }
  let(:user) { create(:user, program: program) }
  let(:facility) { create(:facility, program: program) }
  let(:indicator1) { create(:indicator, categorizable: facility) }
  let(:indicator2) { create(:indicator, categorizable: facility) }
  let(:scorecard) { create(:scorecard, program: program, facility: facility, creator: user, voting_open: voting_open) }

  describe "GET #show" do
    context "when voting is open" do
      let(:voting_open) { true }

      it "renders the voting form" do
        get :show, params: { scorecard_uuid: scorecard.uuid }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:scorecard)).to eq(scorecard)
        expect(assigns(:participant)).to be_a_new(Participant)
        expect(assigns(:indicators)).to include(indicator1, indicator2)
      end
    end

    context "when voting is closed" do
      let(:voting_open) { false }

      it "shows voting closed message" do
        get :show, params: { scorecard_uuid: scorecard.uuid }
        
        expect(response).to have_http_status(:success)
        expect(assigns(:voting_closed)).to be true
      end
    end

    context "when scorecard does not exist" do
      it "returns not found" do
        get :show, params: { scorecard_uuid: "invalid-uuid" }
        
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
      let(:voting_open) { true }

      it "creates participant and voting records" do
        expect {
          post :create, params: request_params, format: :json
        }.to change(Participant, :count).by(1)
          .and change(VotingIndicator, :count).by(2)
          .and change(Rating, :count).by(2)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true

        participant = Participant.last
        expect(participant.age).to eq(25)
        expect(participant.gender).to eq("female")
        expect(participant.youth).to be true
        expect(participant.countable).to be false
      end

      it "associates ratings with participant and voting indicators" do
        post :create, params: request_params, format: :json

        participant = Participant.last
        ratings = Rating.where(participant_uuid: participant.uuid)
        
        expect(ratings.count).to eq(2)
        expect(ratings.pluck(:score)).to match_array([4, 5])
      end
    end

    context "when voting is closed" do
      let(:voting_open) { false }

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
      let(:voting_open) { true }

      it "returns error message about voting ended" do
        scorecard.update(voting_open: false)
        
        post :create, params: request_params, format: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("public_votes.voting_ended"))
      end
    end

    context "with invalid participant data" do
      let(:voting_open) { true }
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
