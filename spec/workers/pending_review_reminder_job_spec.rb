# frozen_string_literal: true

require "rails_helper"

RSpec.describe PendingReviewReminderJob do
  describe "#perform" do
    let(:program) { create(:program, enable_email_notification: true) }
    let(:scorecard) { create(:scorecard, :submitted, program: program, submitted_at: 3.days.ago) }

    before do
      described_class.clear
    end

    it "emails the creator and submitter and schedules the next reminder from submission" do
      delivery = double(deliver_now: true)
      expect(NotificationMailer).to receive(:pending_review_reminder)
        .with([scorecard.creator.email, scorecard.submitter.email], scorecard)
        .and_return(delivery)

      described_class.new.perform(scorecard.id)

      expect(described_class.jobs.last["at"]).to be_within(5).of((scorecard.submitted_at + 6.days).to_f)
    end

    it "does not send a reminder before three days have elapsed" do
      scorecard.update!(submitted_at: 2.days.ago)

      expect(NotificationMailer).not_to receive(:pending_review_reminder)

      described_class.new.perform(scorecard.id)

      expect(described_class.jobs.last["at"]).to be_within(5).of((scorecard.submitted_at + 3.days).to_f)
    end

    it "stops reminding after completion" do
      scorecard.completed_by(create(:user))

      expect(NotificationMailer).not_to receive(:pending_review_reminder)

      described_class.new.perform(scorecard.id)

      expect(described_class.jobs).to be_empty
    end
  end
end
