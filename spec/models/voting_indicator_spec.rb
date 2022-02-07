# frozen_string_literal: true

# == Schema Information
#
# Table name: voting_indicators
#
#  indicatorable_id   :integer
#  indicatorable_type :string
#  scorecard_uuid     :string
#  median             :integer
#  strength           :text
#  weakness           :text
#  suggested_action   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  uuid               :string           default("uuid_generate_v4()"), not null, primary key
#  display_order      :integer
#  indicator_uuid     :string
#
require "rails_helper"

RSpec.describe VotingIndicator, type: :model do
  it { is_expected.to belong_to(:scorecard).optional }
  it { is_expected.to belong_to(:indicatorable) }
  it { is_expected.to have_many(:ratings).dependent(:destroy) }
  it { is_expected.to have_many(:raised_indicators) }

  describe "#after_validation, set_indicator_activities" do
    context "no indicator_activities is passed" do
      let!(:user)       { create(:user) }
      let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
      let!(:indicator)  { facility.indicators.first }
      let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
      let(:params)      { { voting_indicators_attributes: [ {
                            uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, scorecard_uuid: scorecard.uuid, display_order: 1,
                            strength: ["strength1"],
                            weakness: ["weakness1"],
                            suggested_actions_attributes: [
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action1", selected: true },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action2", selected: false },
                            ]
                          }] }
                        }
      let(:voting_indicators) { scorecard.reload.voting_indicators }

      before {
        scorecard.update(params)
      }

      it { expect(voting_indicators.length).to eq(1) }
      it { expect(voting_indicators.first.strength_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.weakness_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.suggested_indicator_activities.length).to eq(2) }
    end

    context "indicator_activities is passed" do
      let!(:user)       { create(:user) }
      let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
      let!(:indicator)   { facility.indicators.first }
      let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
      let(:params)      { { voting_indicators_attributes: [ {
                            uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, scorecard_uuid: scorecard.uuid, display_order: 1,
                            strength: ["strength1"],
                            weakness: ["weakness1"],
                            suggested_actions_attributes: [
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action1", selected: true },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action2", selected: false },
                            ],
                            indicator_activities_attributes: [
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "strength1", selected: false, type: "StrengthIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "weakness1", selected: false, type: "WeaknessIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action1", selected: true, type: "SuggestedIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action2", selected: false, type: "SuggestedIndicatorActivity" }
                            ]
                          }] }
                        }
      let(:voting_indicators) { scorecard.reload.voting_indicators }

      before {
        scorecard.update(params)
      }

      it { expect(voting_indicators.length).to eq(1) }
      it { expect(voting_indicators.first.strength_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.weakness_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.suggested_indicator_activities.length).to eq(2) }
    end

    context "indicator_activities is passed" do
      let!(:user)       { create(:user) }
      let!(:facility)   { create(:facility, :with_parent, :with_indicators) }
      let!(:indicator)   { facility.indicators.first }
      let!(:scorecard)  { create(:scorecard, number_of_participant: 3, program: user.program, facility: facility) }
      let(:params)      { { voting_indicators_attributes: [ {
                            uuid: "123", indicatorable_id: indicator.id, indicatorable_type: indicator.class, scorecard_uuid: scorecard.uuid, display_order: 1,
                            indicator_activities_attributes: [
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "strength1", selected: false, type: "StrengthIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "weakness1", selected: false, type: "WeaknessIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action1", selected: true, type: "SuggestedIndicatorActivity" },
                              { voting_indicator_uuid: "123", scorecard_uuid: scorecard.uuid, content: "action2", selected: false, type: "SuggestedIndicatorActivity" }
                            ]
                          }] }
                        }
      let(:voting_indicators) { scorecard.reload.voting_indicators }

      before {
        scorecard.update(params)
      }

      it { expect(voting_indicators.length).to eq(1) }
      it { expect(voting_indicators.first.strength_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.weakness_indicator_activities.length).to eq(1) }
      it { expect(voting_indicators.first.suggested_indicator_activities.length).to eq(2) }
    end
  end
end
