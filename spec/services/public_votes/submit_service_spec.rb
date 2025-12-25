# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicVotes::SubmitService do
  let(:scorecard) { instance_double("Scorecard", id: 123) }
  let(:form) { instance_double("PublicVoteForm", save: save_result, scorecard: scorecard) }

  subject(:service) { described_class.new(form) }

  before do
    allow(CalculateVotingResultsWorker).to receive(:perform_async)
  end

  context "when form save fails" do
    let(:save_result) { false }

    it "returns false and does not enqueue the worker" do
      expect(service.call).to eq(false)
      expect(CalculateVotingResultsWorker).not_to have_received(:perform_async)
    end
  end

  context "when form save succeeds" do
    let(:save_result) { true }

    it "enqueues results calculation and returns true" do
      expect(service.call).to eq(true)
      expect(CalculateVotingResultsWorker).to have_received(:perform_async).with(123)
    end
  end
end
