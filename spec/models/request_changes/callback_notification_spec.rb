# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestChanges::CallbackNotification do
  describe "#submitted, send notification" do
    it { expect { create(:request_change) }.to change(RequestChangeWorker.jobs, :size).by(1) }
  end

  describe "#after_save, send notification" do
    let!(:request_change) { create(:request_change) }
    let!(:reviewer) { create(:user) }

    context "approved" do
      it {
        expect {
          request_change.update(status: :approved, reviewer: reviewer)
        }.to change(RequestChangeWorker.jobs, :size).by(1)
        args = RequestChangeWorker.jobs.last["args"]
        expect(args).to eq(["notify_status_approved_to_proposer", request_change.id])
      }
    end

    context "rejected" do
      it {
        expect {
          request_change.update(status: :rejected, reviewer: reviewer, rejected_reason: "I reject it")
        }.to change(RequestChangeWorker.jobs, :size).by(1)
        args = RequestChangeWorker.jobs.last["args"]
        expect(args).to eq(["notify_status_rejected_to_proposer", request_change.id])
      }
    end
  end

  describe "#notify_status_rejected_to_proposer" do
    let(:reviewer) { create(:user) }
    let(:request_change) { create(:request_change, rejected_reason: "Bad request", status: :rejected, reviewer: reviewer) }

    it "sends an email via NotificationMailer with expected payload" do
      mail = double("mail")
      expect(mail).to receive(:deliver_now)

      expect(NotificationMailer).to receive(:notify_request_change).with(
        request_change.proposer.email,
        hash_including(:scorecard, :request_change, :body_message)
      ).and_return(mail)

      request_change.notify_status_rejected_to_proposer
    end
  end
end
