# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::FinalizeSubmission do
  describe "#call" do
    let!(:scorecard_offline) { create(:scorecard, running_mode: "offline") }
    let!(:scorecard_online)  { create(:scorecard, running_mode: "online") }
    let!(:submitter) { create(:user) }

    it "does nothing when submission is already locked" do
      scorecard_online.update!(submitted_at: Time.now.utc, submitter_id: submitter.id)

      expect {
        described_class.new(scorecard_online).call
      }.not_to change { scorecard_online.reload.submitted_at }
    end

    it "locks submission for offline scorecards without demographics calculation" do
      expect(scorecard_offline.submitted_at).to be_nil
      expect(scorecard_offline.progress).not_to eq(Scorecard::STATUS_IN_REVIEW)

      described_class.new(scorecard_offline).call

      scorecard_offline.reload
      expect(scorecard_offline.submitted_at).to be_present
      expect(scorecard_offline.progress).to eq(Scorecard::STATUS_IN_REVIEW)
      expect(scorecard_offline.number_of_participant).to be_nil
      expect(scorecard_offline.number_of_female).to be_nil
      expect(scorecard_offline.number_of_disability).to be_nil
      expect(scorecard_offline.number_of_ethnic_minority).to be_nil
      expect(scorecard_offline.number_of_youth).to be_nil
      expect(scorecard_offline.number_of_id_poor).to be_nil
    end

    it "computes demographics for online scorecards and locks submission" do
      # countable participants
      Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: true, minority: true, youth: true, poor_card: false, countable: true)
      Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: false, minority: false, youth: true, poor_card: true, countable: true)
      Participant.create!(scorecard_uuid: scorecard_online.id, gender: "male",   disability: false, minority: false, youth: false, poor_card: false, countable: true)
      # non-countable participant should be ignored
      Participant.create!(scorecard_uuid: scorecard_online.id, gender: "female", disability: true, minority: true, youth: true, poor_card: true, countable: false)

      described_class.new(scorecard_online).call

      scorecard_online.reload
      expect(scorecard_online.submitted_at).to be_present
      expect(scorecard_online.progress).to eq(Scorecard::STATUS_IN_REVIEW)

      expect(scorecard_online.number_of_participant).to eq(3)
      expect(scorecard_online.number_of_female).to eq(2)
      expect(scorecard_online.number_of_disability).to eq(1)
      expect(scorecard_online.number_of_ethnic_minority).to eq(1)
      expect(scorecard_online.number_of_youth).to eq(2)
      expect(scorecard_online.number_of_id_poor).to eq(1)
    end
  end
end
