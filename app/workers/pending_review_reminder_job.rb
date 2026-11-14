# frozen_string_literal: true

class PendingReviewReminderJob
  include Sidekiq::Worker

  REMINDER_INTERVAL = 3.days

  def perform(scorecard_id)
    scorecard = Scorecard.find_by(id: scorecard_id)
    return unless pending_review?(scorecard)

    elapsed_intervals = ((Time.current - scorecard.submitted_at) / REMINDER_INTERVAL).floor
    next_reminder_at = scorecard.submitted_at + (elapsed_intervals + 1) * REMINDER_INTERVAL

    if elapsed_intervals.positive?
      recipients = [scorecard.creator&.email, scorecard.submitter&.email].compact_blank.uniq
      NotificationMailer.pending_review_reminder(recipients, scorecard).deliver_now if recipients.any?
    end

    self.class.perform_at(next_reminder_at, scorecard.id)
  end

  private
    def pending_review?(scorecard)
      scorecard.present? && scorecard.in_review? && scorecard.completed_at.nil? && scorecard.submitted_at.present?
    end
end
