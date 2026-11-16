# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::PendingReviewReminderConcern do
  describe "#pending_review?" do
    it "is true when in review, not completed, and submitted" do
      scorecard = create(:scorecard, :submitted)
      expect(scorecard.pending_review?).to be true
    end

    it "is false when not in review" do
      scorecard = create(:scorecard, :planned)
      expect(scorecard.pending_review?).to be false
    end

    it "is false once completed" do
      scorecard = create(:scorecard, :submitted, :completed)
      expect(scorecard.pending_review?).to be false
    end

    it "is false when not yet submitted" do
      scorecard = create(:scorecard, progress: "in_review", submitted_at: nil)
      expect(scorecard.pending_review?).to be false
    end
  end

  describe "#schedule_pending_review_reminder" do
    let(:scorecard) { create(:scorecard, :submitted) }

    before { PendingReviewReminderJob.clear }

    it "schedules a reminder job for submitted_at + REMINDER_INTERVAL" do
      scorecard.schedule_pending_review_reminder

      job = PendingReviewReminderJob.jobs.last
      expect(job["args"]).to eq([scorecard.id])
      expect(job["at"]).to be_within(5).of((scorecard.submitted_at + described_class::REMINDER_INTERVAL).to_f)
    end
  end

  describe "#send_pending_review_reminder!" do
    before { PendingReviewReminderJob.clear }

    context "when the scorecard is not pending review" do
      it "does not notify or reschedule" do
        scorecard = create(:scorecard, :submitted, :completed)

        expect(NotificationMailer).not_to receive(:pending_review_reminder)

        scorecard.send_pending_review_reminder!

        expect(PendingReviewReminderJob.jobs).to be_empty
      end
    end

    context "before the first interval has elapsed" do
      it "reschedules without sending a notification" do
        scorecard = create(:scorecard, :submitted, submitted_at: 1.day.ago)

        expect(NotificationMailer).not_to receive(:pending_review_reminder)

        scorecard.send_pending_review_reminder!

        job = PendingReviewReminderJob.jobs.last
        expect(job["args"]).to eq([scorecard.id])
        expect(job["at"]).to be_within(5).of((scorecard.submitted_at + described_class::REMINDER_INTERVAL).to_f)
      end
    end

    context "after an interval has elapsed" do
      it "emails the creator and submitter and schedules the next reminder" do
        scorecard = create(:scorecard, :submitted, submitted_at: 3.days.ago)
        delivery = double(deliver_now: true)

        expect(NotificationMailer).to receive(:pending_review_reminder)
          .with([scorecard.creator.email, scorecard.submitter.email], scorecard)
          .and_return(delivery)

        scorecard.send_pending_review_reminder!

        job = PendingReviewReminderJob.jobs.last
        expect(job["args"]).to eq([scorecard.id])
        expect(job["at"]).to be_within(5).of((scorecard.submitted_at + 2 * described_class::REMINDER_INTERVAL).to_f)
      end
    end
  end
end
