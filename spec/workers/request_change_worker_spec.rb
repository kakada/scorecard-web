# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestChangeWorker do
  describe "#perform" do
    let!(:request_change) { create(:request_change) }

    it "invokes the target method on the RequestChange instance" do
      expect_any_instance_of(RequestChange).to receive(:notify_status_rejected_to_proposer)

      described_class.new.perform("notify_status_rejected_to_proposer", request_change.id)
    end

    it "logs and returns gracefully when record not found" do
      allow(Rails.logger).to receive(:error)

      expect {
        described_class.new.perform("notify_status_rejected_to_proposer", 0)
      }.not_to raise_error

      expect(Rails.logger).to have_received(:error)
    end
  end
end
