# frozen_string_literal: true

module Scorecards::PendingReviewReminderConcern
  extend ActiveSupport::Concern

  REMINDER_INTERVAL = 3.days

  included do
    def pending_review?
      in_review? && completed_at.nil? && submitted_at.present?
    end

    def schedule_pending_review_reminder
      PendingReviewReminderJob.perform_at(submitted_at + REMINDER_INTERVAL, id)
    end

    def send_pending_review_reminder!
      return unless pending_review?

      elapsed_intervals = ((Time.current - submitted_at) / REMINDER_INTERVAL).floor
      notify_pending_review_reminder if elapsed_intervals.positive?

      PendingReviewReminderJob.perform_at(submitted_at + (elapsed_intervals + 1) * REMINDER_INTERVAL, id)
    end

    private
      def notify_pending_review_reminder
        recipients = [creator&.email, submitter&.email].compact_blank.uniq
        return if recipients.empty?

        NotificationMailer.pending_review_reminder(recipients, self).deliver_now
      end
  end
end
