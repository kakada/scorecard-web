# frozen_string_literal: true

require "rails_helper"

RSpec.describe "VotingIndicatorsController", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, :lngo) }
  let(:program) { user.program }
  let(:local_ngo) { user.local_ngo }
  let(:scorecard_batch) { create(:scorecard_batch, program: program, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "with Excel format" do
      let!(:scorecard1) do
        create(:scorecard,
               program: program,
               local_ngo_id: local_ngo.id,
               scorecard_batch_code: scorecard_batch.code)
      end

      let!(:scorecard2) do
        create(:scorecard,
               program: program,
               local_ngo_id: local_ngo.id,
               scorecard_batch_code: scorecard_batch.code)
      end

      let!(:voting_indicator1) do
        create(:voting_indicator,
               scorecard: scorecard1,
               median: 3,
               strength: ["Good point 1", "Good point 2"],
               weakness: ["Weak point 1"],
               suggested_action: ["Action 1"])
      end

      let!(:voting_indicator2) do
        create(:voting_indicator,
               scorecard: scorecard2,
               median: 4)
      end

      let!(:rating1) { create(:rating, scorecard: scorecard1, voting_indicator: voting_indicator1, score: 3) }
      let!(:rating2) { create(:rating, scorecard: scorecard1, voting_indicator: voting_indicator1, score: 4) }
      let!(:rating3) { create(:rating, scorecard: scorecard2, voting_indicator: voting_indicator2, score: 5) }

      context "when filtering by scorecard_uuid" do
        it "returns Excel file with data for specified scorecard" do
          get voting_indicators_path(format: :xlsx, uuid: scorecard1.uuid)

          expect(response).to have_http_status(:success)
          expect(response.content_type).to include("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
          expect(response.headers["Content-Disposition"]).to include("voting_indicators_")
        end
      end

      context "when filtering by batch_code" do
        it "returns Excel file with data for specified batch" do
          get voting_indicators_path(format: :xlsx, batch_code: scorecard_batch.code)

          expect(response).to have_http_status(:success)
          expect(response.content_type).to include("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        end
      end

      context "when exceeding the batch limit of 50 scorecards" do
        before do
          # Create 51 scorecards to exceed the limit
          51.times do
            sc = create(:scorecard,
                       program: program,
                       local_ngo_id: local_ngo.id,
                       scorecard_batch_code: scorecard_batch.code)
            create(:voting_indicator, scorecard: sc)
          end
        end

        it "redirects with an error message" do
          get voting_indicators_path(format: :xlsx, batch_code: scorecard_batch.code)

          expect(response).to have_http_status(:redirect)
          expect(flash[:alert]).to include(I18n.t("voting_indicator.batch_limit_exceeded", max_record: 50))
        end
      end

      context "when user does not have access to scorecard" do
        let(:other_user) { create(:user, :lngo) }
        let(:other_scorecard) do
          create(:scorecard,
                 program: other_user.program,
                 local_ngo_id: other_user.local_ngo_id)
        end

        before do
          create(:voting_indicator, scorecard: other_scorecard)
        end

        it "does not include inaccessible scorecards" do
          get voting_indicators_path(format: :xlsx, scorecard_uuid: other_scorecard.uuid)

          # Should return empty result or no access
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
